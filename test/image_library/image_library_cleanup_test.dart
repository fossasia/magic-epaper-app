import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/image_library/models/saved_image_model.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/path_provider');
  final imageBytes = Uint8List.fromList([1, 2, 3]);
  late Directory root;
  late Directory temporaryDirectory;
  late Directory libraryDirectory;
  late File metadataFile;
  late ImageLibraryProvider provider;

  Map<String, dynamic> contactMetadata(File image) => {
        'contactCard': {'profileImagePath': image.path},
      };

  Future<File> createImage(String filePath) async {
    final file = File(filePath);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(imageBytes);
    return file;
  }

  Future<void> seedLegacyCards(File crop, List<String> ids) async {
    final images = <SavedImage>[];
    for (final id in ids) {
      final rendered = await createImage(
        '${libraryDirectory.path}/images/${id}_contact.png',
      );
      images.add(SavedImage(
        id: id,
        name: 'Contact $id',
        filePath: rendered.path,
        createdAt: DateTime(2026),
        source: 'template',
        metadata: contactMetadata(crop),
      ));
    }
    await metadataFile.writeAsString(
      jsonEncode(images.map((image) => image.toJson()).toList()),
    );
    await provider.loadSavedImages();
  }

  setUp(() async {
    root = await Directory.systemTemp.createTemp('image_library_cleanup_');
    temporaryDirectory = await Directory('${root.path}/temporary').create();
    libraryDirectory = Directory('${root.path}/documents/MagicEpaper');
    metadataFile = File('${libraryDirectory.path}/images_metadata.json');
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
    provider.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await root.delete(recursive: true);
  });

  test('clear removes metadata sidecars before a fresh load', () async {
    await provider.saveImage(
      name: 'Contact',
      imageData: imageBytes,
      source: 'template',
      metadata: {
        'contactCard': {'profileImageBytes': imageBytes},
      },
    );
    final savedImage = provider.savedImages.single;
    final profilePath =
        savedImage.contactCardData!['profileImagePath'] as String;
    final staleMetadata = await metadataFile.readAsString();
    for (final suffix in ['.tmp', '.bak']) {
      await File('${metadataFile.path}$suffix').writeAsString(staleMetadata);
    }

    await provider.clearAllData();

    for (final suffix in ['', '.tmp', '.bak']) {
      expect(await File('${metadataFile.path}$suffix').exists(), isFalse);
    }
    expect(await File(savedImage.filePath).exists(), isFalse);
    expect(await File(profilePath).exists(), isFalse);
    final restarted = ImageLibraryProvider();
    try {
      await restarted.loadSavedImages();
      expect(restarted.savedImages, isEmpty);
      expect(await metadataFile.exists(), isFalse);
    } finally {
      restarted.dispose();
    }
  });

  test('save deletes an owned crop only after migration is persisted',
      () async {
    final crop = await createImage('${temporaryDirectory.path}/mep_crop_1.png');
    await provider.saveImage(
      name: 'Contact',
      imageData: imageBytes,
      source: 'template',
      metadata: contactMetadata(crop),
    );

    final savedImage = provider.savedImages.single;
    final profilePath =
        savedImage.contactCardData!['profileImagePath'] as String;
    expect(await File(profilePath).readAsBytes(), imageBytes);
    expect(await crop.exists(), isFalse);
    final persisted = jsonDecode(await metadataFile.readAsString()) as List;
    expect(persisted.single['metadata']['contactCard']['profileImagePath'],
        profilePath);
  });

  test('update keeps a shared crop until the last card migrates', () async {
    final crop = await createImage('${temporaryDirectory.path}/mep_crop_2.png');
    await seedLegacyCards(crop, ['1', '2']);

    await provider.updateSavedImage('1', metadata: contactMetadata(crop));
    expect(await crop.exists(), isTrue);
    await provider.updateSavedImage('2', metadata: contactMetadata(crop));
    expect(await crop.exists(), isFalse);
    for (final image in provider.savedImages) {
      final profilePath = image.contactCardData!['profileImagePath'] as String;
      expect(await File(profilePath).readAsBytes(), imageBytes);
    }
  });

  test('replacing a legacy crop with image bytes removes the old crop',
      () async {
    final crop = await createImage('${temporaryDirectory.path}/mep_crop_8.png');
    await seedLegacyCards(crop, ['1']);
    final replacementBytes = Uint8List.fromList([4, 5, 6]);

    await provider.updateSavedImage('1', metadata: {
      'contactCard': {'profileImageBytes': replacementBytes},
    });

    expect(await crop.exists(), isFalse);
    final profilePath = provider
        .savedImages.single.contactCardData!['profileImagePath'] as String;
    expect(await File(profilePath).readAsBytes(), replacementBytes);
    final persisted = jsonDecode(await metadataFile.readAsString()) as List;
    expect(persisted.single['metadata']['contactCard']['profileImagePath'],
        profilePath);
  });

  test('delete retains a shared legacy crop until the final card is removed',
      () async {
    final crop = await createImage('${temporaryDirectory.path}/mep_crop_9.png');
    await seedLegacyCards(crop, ['1', '2']);

    await provider.deleteImage('1');
    expect(await crop.readAsBytes(), imageBytes);
    await provider.deleteImage('2');

    expect(await crop.exists(), isFalse);
    expect(provider.savedImages, isEmpty);
    expect(jsonDecode(await metadataFile.readAsString()), isEmpty);
  });

  test('replacement keeps a shared crop until its remaining card is deleted',
      () async {
    final crop =
        await createImage('${temporaryDirectory.path}/mep_crop_10.png');
    await seedLegacyCards(crop, ['1', '2']);

    await provider.updateSavedImage('1', metadata: {
      'contactCard': {
        'profileImageBytes': Uint8List.fromList([4, 5, 6])
      },
    });
    expect(await crop.readAsBytes(), imageBytes);
    await provider.deleteImage('2');

    expect(await crop.exists(), isFalse);
    expect(provider.savedImages.single.id, '1');
  });

  test('clear removes shared legacy crops and preserves external profile files',
      () async {
    final crop =
        await createImage('${temporaryDirectory.path}/mep_crop_11.png');
    await seedLegacyCards(crop, ['1', '2']);
    final externalPhoto =
        await createImage('${root.path}/user/mep_crop_12.png');
    final rendered = await createImage(
      '${libraryDirectory.path}/images/3_external.png',
    );
    final externalCard = SavedImage(
      id: '3',
      name: 'External legacy profile',
      filePath: rendered.path,
      createdAt: DateTime(2026),
      source: 'template',
      metadata: contactMetadata(externalPhoto),
    );
    await metadataFile.writeAsString(jsonEncode(
      [...provider.savedImages, externalCard]
          .map((image) => image.toJson())
          .toList(),
    ));
    await provider.loadSavedImages();

    await provider.clearAllData();

    expect(await crop.exists(), isFalse);
    expect(await externalPhoto.readAsBytes(), imageBytes);
    expect(provider.savedImages, isEmpty);
    expect(await metadataFile.exists(), isFalse);
  });

  test('failed legacy crop replacement preserves the original crop', () async {
    final crop =
        await createImage('${temporaryDirectory.path}/mep_crop_13.png');
    await seedLegacyCards(crop, ['1']);
    final oldMetadata = await metadataFile.readAsString();
    await Directory('${metadataFile.path}.tmp').create();

    await expectLater(
      provider.updateSavedImage('1', metadata: {
        'contactCard': {
          'profileImageBytes': Uint8List.fromList([4, 5, 6])
        },
      }),
      throwsA(isA<FileSystemException>()),
    );

    expect(await crop.readAsBytes(), imageBytes);
    expect(provider.savedImages.single.contactCardData!['profileImagePath'],
        crop.path);
    expect(await metadataFile.readAsString(), oldMetadata);
  });

  test('failed deletion leaves a legacy crop available for recovery', () async {
    final crop =
        await createImage('${temporaryDirectory.path}/mep_crop_14.png');
    await seedLegacyCards(crop, ['1']);
    final oldMetadata = await metadataFile.readAsString();
    await Directory('${metadataFile.path}.tmp').create();

    await expectLater(
      provider.deleteImage('1'),
      throwsA(isA<FileSystemException>()),
    );

    expect(await crop.readAsBytes(), imageBytes);
    expect(await metadataFile.readAsString(), oldMetadata);
  });

  test('failed save keeps the legacy crop and removes managed files', () async {
    final crop = await createImage('${temporaryDirectory.path}/mep_crop_3.png');
    await Directory('${metadataFile.path}.tmp').create();

    await expectLater(
      provider.saveImage(
        name: 'Contact',
        imageData: imageBytes,
        source: 'template',
        metadata: contactMetadata(crop),
      ),
      throwsA(isA<FileSystemException>()),
    );

    expect(await crop.readAsBytes(), imageBytes);
    expect(provider.savedImages, isEmpty);
    expect(await Directory('${libraryDirectory.path}/images').list().toList(),
        isEmpty);
    expect(
        await Directory('${libraryDirectory.path}/template_assets')
            .list()
            .toList(),
        isEmpty);
  });

  test('failed update retains the crop and original persisted record',
      () async {
    final crop = await createImage('${temporaryDirectory.path}/mep_crop_4.png');
    await seedLegacyCards(crop, ['1']);
    final oldMetadata = await metadataFile.readAsString();
    await Directory('${metadataFile.path}.tmp').create();

    await expectLater(
      provider.updateSavedImage('1', metadata: contactMetadata(crop)),
      throwsA(isA<FileSystemException>()),
    );

    expect(await crop.readAsBytes(), imageBytes);
    expect(provider.savedImages.single.contactCardData!['profileImagePath'],
        crop.path);
    expect(await metadataFile.readAsString(), oldMetadata);
    expect(
        await File(
                '${libraryDirectory.path}/template_assets/1_contact_profile.png')
            .exists(),
        isFalse);
  });

  test('migration preserves external files and unrelated temporary files',
      () async {
    final files = [
      await createImage('${root.path}/user/mep_crop_5.png'),
      await createImage('${temporaryDirectory.path}/user_photo.png'),
      await createImage('${temporaryDirectory.path}/nested/mep_crop_6.png'),
    ];
    for (final file in files) {
      await provider.saveImage(
        name: 'Contact',
        imageData: imageBytes,
        source: 'template',
        metadata: contactMetadata(file),
      );
      expect(await file.readAsBytes(), imageBytes);
    }
  });

  test('migration does not delete a crop-shaped symbolic link', () async {
    final original = await createImage('${root.path}/user/photo.png');
    final link = await Link('${temporaryDirectory.path}/mep_crop_7.png')
        .create(original.path);
    await provider.saveImage(
      name: 'Contact',
      imageData: imageBytes,
      source: 'template',
      metadata: contactMetadata(File(link.path)),
    );

    expect(await link.exists(), isTrue);
    expect(await original.readAsBytes(), imageBytes);
  });
}
