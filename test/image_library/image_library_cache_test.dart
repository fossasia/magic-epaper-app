import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';

class _ImageLibraryTestBinding extends AutomatedTestWidgetsFlutterBinding {
  @override
  ImageCache createImageCache() => _TestImageCache();
}

class _TestImageCache extends ImageCache {
  void Function(Object)? onEvict;

  @override
  bool evict(Object key, {bool includeLive = true}) {
    final result = super.evict(key, includeLive: includeLive);
    onEvict?.call(key);
    return result;
  }
}

class _PartialWriteFile extends Fake implements File {
  _PartialWriteFile(this.delegate);

  final File delegate;
  bool failNextWrite = true;

  @override
  String get path => delegate.path;

  @override
  Future<bool> exists() => delegate.exists();

  @override
  Future<Uint8List> readAsBytes() => delegate.readAsBytes();

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) =>
      delegate.delete(recursive: recursive);

  @override
  Future<File> writeAsBytes(List<int> bytes,
      {FileMode mode = FileMode.write, bool flush = false}) async {
    if (failNextWrite) {
      failNextWrite = false;
      await delegate.writeAsBytes(bytes.take(8).toList(),
          mode: mode, flush: flush);
      throw FileSystemException('Simulated partial image write', path);
    }
    return delegate.writeAsBytes(bytes, mode: mode, flush: flush);
  }
}

void main() {
  final binding = _ImageLibraryTestBinding();
  final cache = binding.imageCache as _TestImageCache;
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  final redBytes = Uint8List.fromList(img.encodePng(
    img.Image(width: 1, height: 1)..setPixelRgba(0, 0, 255, 0, 0, 255),
  ));
  final blueBytes = Uint8List.fromList(img.encodePng(
    img.Image(width: 1, height: 1)..setPixelRgba(0, 0, 0, 0, 255, 255),
  ));
  late Directory root;
  late File metadataFile;
  late ImageLibraryProvider provider;

  Future<List<int>> cachedPixels(File file) async {
    final stream = FileImage(file).resolve(ImageConfiguration.empty);
    final completer = Completer<ImageInfo>();
    final listener = ImageStreamListener(
      (image, synchronousCall) => completer.complete(image),
      onError: (Object error, StackTrace? stackTrace) {
        completer.completeError(error, stackTrace);
      },
    );
    stream.addListener(listener);
    try {
      final imageInfo = await completer.future;
      try {
        final data = await imageInfo.image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        return data!.buffer.asUint8List().toList();
      } finally {
        imageInfo.dispose();
      }
    } finally {
      stream.removeListener(listener);
    }
  }

  Future<File> saveContact() async {
    await provider.saveImage(
      name: 'Contact',
      imageData: redBytes,
      source: 'template',
      metadata: {
        'contactCard': {'profileImageBytes': redBytes},
      },
    );
    return File(
      provider.savedImages.single.contactCardData!['profileImagePath']
          as String,
    );
  }

  Future<void> expectUncached(File file) async {
    final status = await FileImage(file).obtainCacheStatus(
      configuration: ImageConfiguration.empty,
    );
    expect(status!.untracked, isTrue);
  }

  // A preview can decode the replacement while metadata is being persisted.
  // Reproduce that interleaving so rollback must discard those transient pixels.
  Future<void> cacheReplacementAfterNextEviction(File file) async {
    final transientImage = await decodeImageFromList(blueBytes);
    addTearDown(transientImage.dispose);
    cache.onEvict = (key) {
      if (key != FileImage(file)) return;
      cache.onEvict = null;
      cache.putIfAbsent(
        key,
        () => OneFrameImageStreamCompleter(SynchronousFuture(
          ImageInfo(image: transientImage.clone()),
        )),
      );
    };
  }

  setUp(() async {
    root = await Directory.systemTemp.createTemp('image_library_cache_');
    final temporaryDirectory =
        await Directory('${root.path}/temporary').create();
    metadataFile =
        File('${root.path}/documents/MagicEpaper/images_metadata.json');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'getTemporaryDirectory':
          return temporaryDirectory.path;
        case 'getApplicationDocumentsDirectory':
          return '${root.path}/documents';
        case 'getExternalStorageDirectory':
          return null;
        default:
          throw MissingPluginException();
      }
    });
    provider = ImageLibraryProvider();
    await provider.loadSavedImages();
  });

  tearDown(() async {
    cache.onEvict = null;
    cache.clear();
    cache.clearLiveImages();
    provider.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await root.delete(recursive: true);
  });

  test('profile byte replacement decodes fresh pixels at the same path',
      () async {
    final profile = await saveContact();
    final rendered = File(provider.savedImages.single.filePath);
    expect(await cachedPixels(profile), [255, 0, 0, 255]);
    expect(await cachedPixels(rendered), [255, 0, 0, 255]);

    await provider.updateSavedImage(
      provider.savedImages.single.id,
      metadata: {
        'contactCard': {'profileImageBytes': blueBytes},
      },
    );

    expect(provider.savedImages.single.contactCardData!['profileImagePath'],
        profile.path);
    expect(await cachedPixels(profile), [0, 0, 255, 255]);
    final renderedStatus = await FileImage(rendered).obtainCacheStatus(
      configuration: ImageConfiguration.empty,
    );
    expect(renderedStatus!.keepAlive, isTrue);
  });

  test('profile crop replacement decodes fresh pixels after migration',
      () async {
    final profile = await saveContact();
    expect(await cachedPixels(profile), [255, 0, 0, 255]);
    final crop = File('${root.path}/temporary/mep_crop_1.png');
    await crop.writeAsBytes(blueBytes);

    await provider.updateSavedImage(
      provider.savedImages.single.id,
      metadata: {
        'contactCard': {'profileImagePath': crop.path},
      },
    );

    expect(await crop.exists(), isFalse);
    expect(provider.savedImages.single.contactCardData!['profileImagePath'],
        profile.path);
    expect(await cachedPixels(profile), [0, 0, 255, 255]);
  });

  for (final removeContactCard in [false, true]) {
    test(
        'removing ${removeContactCard ? 'the card' : 'the photo'} evicts pixels',
        () async {
      final profile = await saveContact();
      expect(await cachedPixels(profile), [255, 0, 0, 255]);

      await provider.updateSavedImage(
        provider.savedImages.single.id,
        metadata: removeContactCard ? {} : {'contactCard': <String, dynamic>{}},
      );

      expect(await profile.exists(), isFalse);
      await expectUncached(profile);
    });
  }

  for (final clearLibrary in [false, true]) {
    test(
        '${clearLibrary ? 'clearing the library' : 'deleting a card'} evicts images',
        () async {
      final profile = await saveContact();
      final rendered = File(provider.savedImages.single.filePath);
      expect(await cachedPixels(profile), [255, 0, 0, 255]);
      expect(await cachedPixels(rendered), [255, 0, 0, 255]);

      if (clearLibrary) {
        await provider.clearAllData();
      } else {
        await provider.deleteImage(provider.savedImages.single.id);
      }

      for (final file in [profile, rendered]) {
        expect(await file.exists(), isFalse);
        await expectUncached(file);
      }
    });
  }

  test('failed profile replacement restores pixels cached during persistence',
      () async {
    final profile = await saveContact();
    expect(await cachedPixels(profile), [255, 0, 0, 255]);
    final oldMetadata = await metadataFile.readAsString();
    await Directory('${metadataFile.path}.tmp').create();
    await cacheReplacementAfterNextEviction(profile);

    await expectLater(
      provider.updateSavedImage(
        provider.savedImages.single.id,
        metadata: {
          'contactCard': {'profileImageBytes': blueBytes},
        },
      ),
      throwsA(isA<FileSystemException>()),
    );

    expect(cache.onEvict, isNull);
    expect(await metadataFile.readAsString(), oldMetadata);
    expect(await profile.readAsBytes(), redBytes);
    expect(await cachedPixels(profile), [255, 0, 0, 255]);
  });

  test('failed update removes newly created profile pixels from the cache',
      () async {
    await provider.saveImage(
      name: 'Contact',
      imageData: redBytes,
      source: 'template',
      metadata: {'contactCard': <String, dynamic>{}},
    );
    final id = provider.savedImages.single.id;
    final profile = File(
      '${root.path}/documents/MagicEpaper/template_assets/${id}_contact_profile.png',
    );
    await Directory('${metadataFile.path}.tmp').create();
    await cacheReplacementAfterNextEviction(profile);

    await expectLater(
      provider.updateSavedImage(
        id,
        metadata: {
          'contactCard': {'profileImageBytes': blueBytes},
        },
      ),
      throwsA(isA<FileSystemException>()),
    );

    expect(cache.onEvict, isNull);
    expect(await profile.exists(), isFalse);
    expect(provider.savedImages.single.contactCardData!['profileImagePath'],
        isNull);
    await expectUncached(profile);
  });

  test('failed update evicts a rendered image with no previous file', () async {
    await saveContact();
    final rendered = File(provider.savedImages.single.filePath);
    expect(await cachedPixels(rendered), [255, 0, 0, 255]);
    await rendered.delete();
    await Directory('${metadataFile.path}.tmp').create();
    await cacheReplacementAfterNextEviction(rendered);

    await expectLater(
      provider.updateSavedImage(provider.savedImages.single.id,
          imageData: blueBytes),
      throwsA(isA<FileSystemException>()),
    );

    expect(cache.onEvict, isNull);
    expect(await rendered.exists(), isFalse);
    await expectUncached(rendered);
  });

  test('a partial initial image write is removed by save rollback', () async {
    final parentZone = Zone.current;
    final crop = File('${root.path}/temporary/mep_crop_2.png');
    await crop.writeAsBytes(redBytes);
    final partialFiles = <_PartialWriteFile>[];

    await expectLater(
      IOOverrides.runZoned(
        () => provider.saveImage(
          name: 'Contact',
          imageData: redBytes,
          source: 'template',
          metadata: {
            'contactCard': {'profileImagePath': crop.path},
          },
        ),
        createFile: (filePath) {
          final file = parentZone.run(() => File(filePath));
          if (filePath.contains('/MagicEpaper/images/')) {
            final partialFile = _PartialWriteFile(file);
            partialFiles.add(partialFile);
            return partialFile;
          }
          return file;
        },
      ),
      throwsA(isA<FileSystemException>()),
    );

    expect(partialFiles, hasLength(1));
    expect(partialFiles.single.failNextWrite, isFalse);
    expect(await partialFiles.single.delegate.exists(), isFalse);
    expect(provider.savedImages, isEmpty);
    expect(await metadataFile.exists(), isFalse);
    expect(await crop.readAsBytes(), redBytes);
    expect(
        await Directory('${root.path}/documents/MagicEpaper/template_assets')
            .list()
            .toList(),
        isEmpty);
  });

  for (final failProfileWrite in [false, true]) {
    test(
        'partial ${failProfileWrite ? 'profile' : 'rendered'} write restores bytes',
        () async {
      final profile = await saveContact();
      final rendered = File(provider.savedImages.single.filePath);
      final failedFile = failProfileWrite ? profile : rendered;
      expect(await cachedPixels(profile), [255, 0, 0, 255]);
      expect(await cachedPixels(rendered), [255, 0, 0, 255]);
      final oldMetadata = await metadataFile.readAsString();
      final parentZone = Zone.current;
      final partialFile = _PartialWriteFile(failedFile);

      await expectLater(
        IOOverrides.runZoned(
          () => provider.updateSavedImage(
            provider.savedImages.single.id,
            imageData: blueBytes,
            metadata: {
              'contactCard': {'profileImageBytes': blueBytes},
            },
          ),
          createFile: (filePath) => filePath == failedFile.path
              ? partialFile
              : parentZone.run(() => File(filePath)),
        ),
        throwsA(isA<FileSystemException>()),
      );

      expect(partialFile.failNextWrite, isFalse);
      expect(await metadataFile.readAsString(), oldMetadata);
      for (final file in [profile, rendered]) {
        expect(await file.readAsBytes(), redBytes);
        expect(await cachedPixels(file), [255, 0, 0, 255]);
      }
    });
  }
}
