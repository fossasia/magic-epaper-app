import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/models/saved_image_model.dart';

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../utils/app_logger.dart';

class ImageLibraryProvider extends ChangeNotifier {
  List<SavedImage> _savedImages = [];
  List<SavedImage> get savedImages => _savedImages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedSource = 'all';
  String get selectedSource => _selectedSource;

  Directory? _magicEpaperDirectory;
  Directory? _imageDirectory;
  Directory? _templateAssetDirectory;
  File? _metadataFile;
  bool _isInitialized = false;

  List<SavedImage> get filteredImages {
    var filtered = _savedImages.where((image) {
      final matchesSearch = image.name.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesSource =
          _selectedSource == 'all' || image.source == _selectedSource;
      return matchesSearch && matchesSource;
    }).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  Future<void> _initializeDirectories() async {
    if (_magicEpaperDirectory == null) {
      String path;
      try {
        final externalDir = await getExternalStorageDirectory();
        if (Platform.isAndroid && externalDir != null) {
          path = externalDir.path;
        } else {
          path = (await getApplicationDocumentsDirectory()).path;
        }
      } catch (e) {
        AppLogger.error('Error initializing directory path: $e');
        path = (await getApplicationDocumentsDirectory()).path;
      }
      _magicEpaperDirectory = Directory('$path/MagicEpaper');
      if (!await _magicEpaperDirectory!.exists()) {
        await _magicEpaperDirectory!.create(recursive: true);
      }
      _imageDirectory = Directory('${_magicEpaperDirectory!.path}/images');
      if (!await _imageDirectory!.exists()) {
        await _imageDirectory!.create(recursive: true);
      }
      _templateAssetDirectory = Directory(
        '${_magicEpaperDirectory!.path}/template_assets',
      );
      if (!await _templateAssetDirectory!.exists()) {
        await _templateAssetDirectory!.create(recursive: true);
      }
      _metadataFile = File(
        '${_magicEpaperDirectory!.path}/images_metadata.json',
      );
      await _recoverMetadataFileIfNeeded();
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await loadSavedImages();
    }
  }

  Future<void> clearAllData() async {
    try {
      await _ensureInitialized();
      await _initializeDirectories();
      final previousImages = List<SavedImage>.of(_savedImages);
      if (_imageDirectory != null && await _imageDirectory!.exists()) {
        final files = await _imageDirectory!.list().toList();
        for (final file in files) {
          if (file is File) {
            await _deleteImageFile(file);
          }
        }
      }
      if (_templateAssetDirectory != null &&
          await _templateAssetDirectory!.exists()) {
        final files = await _templateAssetDirectory!.list().toList();
        for (final file in files) {
          if (file is File) {
            await _deleteImageFile(file);
          }
        }
      }
      if (_metadataFile != null) {
        for (final suffix in ['.tmp', '.bak', '']) {
          final file = File('${_metadataFile!.path}$suffix');
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
      _savedImages.clear();
      _searchQuery = '';
      _selectedSource = 'all';

      for (final image in previousImages) {
        await _cleanupUnreferencedProfileImage(image.metadata);
      }

      AppLogger.info('All data cleared successfully');
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error clearing all data: $e');
      rethrow;
    }
  }

  Future<void> loadSavedImages() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    var metadataLoadedSuccessfully = false;
    final validTemplateAssetIds = <String>{};
    try {
      await _initializeDirectories();
      _savedImages = [];

      if (await _metadataFile!.exists()) {
        final jsonString = await _metadataFile!.readAsString();
        if (jsonString.isEmpty) {
          AppLogger.warning(
            'Metadata file is empty; skipping destructive orphan cleanup',
          );
        } else {
          try {
            final decoded = jsonDecode(jsonString);
            if (decoded is! List) {
              throw const FormatException('Image metadata root is not a list');
            }

            metadataLoadedSuccessfully = true;
            for (final json in decoded) {
              try {
                final image = SavedImage.fromJson(json);
                validTemplateAssetIds.add(image.id);
                if (await image.fileExists()) {
                  _savedImages.add(image);
                } else {
                  AppLogger.warning('Image file not found: ${image.filePath}');
                }
              } catch (e) {
                metadataLoadedSuccessfully = false;
                AppLogger.error('Error parsing individual image metadata: $e');
              }
            }
          } catch (e) {
            AppLogger.error('Error parsing JSON metadata file: $e');
          }
        }
      } else {
        AppLogger.debug(
          'Metadata file not found; skipping destructive orphan cleanup',
        );
      }

      if (_savedImages.isNotEmpty) {
        const encoder = JsonEncoder.withIndent('  ');
        final imageJsonList = _savedImages.map((img) => img.toJson()).toList();
        final prettyJson = encoder.convert(imageJsonList);
        AppLogger.debug('Loaded image metadata (JSON):\n$prettyJson');
      } else {
        AppLogger.debug('No saved images to print.');
      }

      if (metadataLoadedSuccessfully) {
        await _cleanupOrphanedFiles();
        await _cleanupOrphanedTemplateAssets(validTemplateAssetIds);
      } else {
        AppLogger.warning(
          'Skipping orphan cleanup because metadata was not loaded completely',
        );
      }

      AppLogger.info('Loaded ${_savedImages.length} images successfully');
      _isInitialized = true;
    } catch (e) {
      AppLogger.error('Error loading saved images: $e');
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveImage({
    required String name,
    required Uint8List imageData,
    required String source,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _ensureInitialized();
      await _initializeDirectories();
      final imageId = DateTime.now().millisecondsSinceEpoch.toString();
      final fileName =
          '${imageId}_${name.replaceAll(RegExp(r'[^\w\s-]'), '')}.png';
      final filePath = '${_imageDirectory!.path}/$fileName';
      final file = File(filePath);

      SavedImage? savedImage;
      try {
        await file.writeAsBytes(imageData);
        final storedMetadata =
            await _prepareTemplateMetadata(imageId, metadata);
        savedImage = SavedImage(
          id: imageId,
          name: name,
          filePath: filePath,
          createdAt: DateTime.now(),
          source: source,
          metadata: storedMetadata,
        );
        _savedImages.add(savedImage);
        await _persistMetadata();
      } catch (error) {
        if (savedImage != null) {
          _savedImages.remove(savedImage);
        }

        try {
          if (await file.exists()) {
            await _deleteImageFile(file);
          }
          await _deleteTemplateAssets(imageId);
        } catch (rollbackError, rollbackStackTrace) {
          AppLogger.error(
            'Error rolling back saved image',
            rollbackError,
            rollbackStackTrace,
          );
        }

        rethrow;
      }

      await _cleanupUnreferencedProfileImage(metadata);
      AppLogger.info(
        'Successfully saved image: $name (${imageData.length} bytes)',
      );
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error saving image: $e');
      rethrow;
    }
  }

  Future<void> updateSavedImage(
    String id, {
    Uint8List? imageData,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _ensureInitialized();
      await _initializeDirectories();
      final index = _savedImages.indexWhere((image) => image.id == id);
      if (index == -1) return;

      final old = _savedImages[index];
      final imageFile = File(old.filePath);
      final previousImageBytes = imageData != null && await imageFile.exists()
          ? await imageFile.readAsBytes()
          : null;

      final rawContactCard = metadata?['contactCard'];
      final profileAsset = metadata != null
          ? File('${_templateAssetDirectory!.path}/${id}_contact_profile.png')
          : null;
      final previousProfileBytes =
          profileAsset != null && await profileAsset.exists()
              ? await profileAsset.readAsBytes()
              : null;

      try {
        if (imageData != null) {
          await imageFile.writeAsBytes(imageData);
          await FileImage(imageFile).evict();
        }

        final storedMetadata = metadata == null
            ? old.metadata
            : await _prepareTemplateMetadata(id, metadata);

        if (metadata != null &&
            rawContactCard is! Map &&
            profileAsset != null &&
            await profileAsset.exists()) {
          await _deleteImageFile(profileAsset);
        }

        _savedImages[index] = SavedImage(
          id: old.id,
          name: old.name,
          filePath: old.filePath,
          createdAt: old.createdAt,
          source: old.source,
          metadata: storedMetadata,
        );
        await _persistMetadata();
      } catch (error) {
        _savedImages[index] = old;

        try {
          if (imageData != null) {
            if (previousImageBytes != null) {
              await imageFile.writeAsBytes(previousImageBytes);
              await FileImage(imageFile).evict();
            } else if (await imageFile.exists()) {
              await _deleteImageFile(imageFile);
            }
          }

          if (profileAsset != null) {
            if (previousProfileBytes != null) {
              await profileAsset.writeAsBytes(previousProfileBytes);
              await FileImage(profileAsset).evict();
            } else if (await profileAsset.exists()) {
              await _deleteImageFile(profileAsset);
            }
          }
        } catch (rollbackError, rollbackStackTrace) {
          AppLogger.error(
            'Error rolling back saved image update',
            rollbackError,
            rollbackStackTrace,
          );
        }

        rethrow;
      }

      if (metadata != null) {
        await _cleanupUnreferencedProfileImage(metadata);
        await _cleanupUnreferencedProfileImage(old.metadata);
      }
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error updating saved image: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(String id) async {
    try {
      await _ensureInitialized();
      final imageIndex = _savedImages.indexWhere((image) => image.id == id);
      if (imageIndex == -1) return;
      final image = _savedImages[imageIndex];
      final previousImages = _savedImages;
      _savedImages = List<SavedImage>.of(previousImages)..removeAt(imageIndex);
      try {
        await _persistMetadata();
      } catch (_) {
        _savedImages = previousImages;
        rethrow;
      }

      try {
        final file = File(image.filePath);
        if (await file.exists()) {
          await _deleteImageFile(file);
        }
      } catch (error, stackTrace) {
        AppLogger.warning(
          'Failed to clean up deleted image file',
          error,
          stackTrace,
        );
      }
      try {
        await _deleteTemplateAssets(id);
      } catch (error, stackTrace) {
        AppLogger.warning(
          'Failed to clean up deleted image profile asset',
          error,
          stackTrace,
        );
      }
      await _cleanupUnreferencedProfileImage(image.metadata);
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error deleting image: $e');
      rethrow;
    }
  }

  Future<void> renameImage(String id, String newName) async {
    try {
      await _ensureInitialized();
      final index = _savedImages.indexWhere((image) => image.id == id);
      if (index == -1) return;
      final oldImage = _savedImages[index];
      _savedImages[index] = SavedImage(
        id: oldImage.id,
        name: newName,
        filePath: oldImage.filePath,
        createdAt: oldImage.createdAt,
        source: oldImage.source,
        metadata: oldImage.metadata,
      );
      await _persistMetadata();
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error renaming image: $e');
      rethrow;
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSourceFilter(String source) {
    _selectedSource = source;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> _prepareTemplateMetadata(
    String imageId,
    Map<String, dynamic>? metadata,
  ) async {
    if (metadata == null) return null;

    final result = Map<String, dynamic>.from(metadata);
    final rawContactCard = result['contactCard'];
    if (rawContactCard is! Map) return result;

    final contactCard = Map<String, dynamic>.from(rawContactCard);
    final profileImageBytes = contactCard.remove('profileImageBytes');
    final targetFile = File(
      '${_templateAssetDirectory!.path}/${imageId}_contact_profile.png',
    );

    if (profileImageBytes is Uint8List) {
      await targetFile.writeAsBytes(profileImageBytes);
      await FileImage(targetFile).evict();
      contactCard['profileImagePath'] = targetFile.path;
    } else {
      final currentPath = contactCard['profileImagePath'];
      if (currentPath is String && currentPath != targetFile.path) {
        final currentFile = File(currentPath);
        if (await currentFile.exists()) {
          await currentFile.copy(targetFile.path);
          await FileImage(targetFile).evict();
          contactCard['profileImagePath'] = targetFile.path;
        }
      } else if (currentPath is! String && await targetFile.exists()) {
        await _deleteImageFile(targetFile);
      }
    }

    result['contactCard'] = contactCard;
    return result;
  }

  Future<void> _cleanupUnreferencedProfileImage(
    Map<String, dynamic>? metadata,
  ) async {
    final card = metadata?['contactCard'];
    if (card is! Map) return;
    final sourcePath = card['profileImagePath'];
    if (sourcePath is! String) return;

    try {
      final sourceFile = File(sourcePath);
      if (await FileSystemEntity.type(sourcePath, followLinks: false) !=
          FileSystemEntityType.file) {
        return;
      }
      final tempDirectory = await getTemporaryDirectory();
      final tempPath = await tempDirectory.resolveSymbolicLinks();
      final resolvedSourcePath = await sourceFile.resolveSymbolicLinks();
      if (!path.equals(path.dirname(resolvedSourcePath), tempPath) ||
          !RegExp(r'^mep_crop_\d+\.png$')
              .hasMatch(path.basename(resolvedSourcePath))) {
        return;
      }

      for (final image in _savedImages) {
        final card = image.metadata?['contactCard'];
        final referencedPath = card is Map ? card['profileImagePath'] : null;
        if (referencedPath is String &&
            await File(referencedPath).exists() &&
            path.equals(
              await File(referencedPath).resolveSymbolicLinks(),
              resolvedSourcePath,
            )) {
          return;
        }
      }

      await _deleteImageFile(sourceFile);
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Failed to clean up unused temporary profile image',
        error,
        stackTrace,
      );
    }
  }

  Future<void> _deleteTemplateAssets(String imageId) async {
    if (_templateAssetDirectory == null) return;
    final profileFile = File(
      '${_templateAssetDirectory!.path}/${imageId}_contact_profile.png',
    );
    if (await profileFile.exists()) {
      await _deleteImageFile(profileFile);
    }
  }

  Future<void> _deleteImageFile(File file) async {
    await file.delete();
    await FileImage(file).evict();
  }

  Future<void> _recoverMetadataFileIfNeeded() async {
    if (_metadataFile == null) return;

    final tempFile = File('${_metadataFile!.path}.tmp');
    final backupFile = File('${_metadataFile!.path}.bak');

    if (!await _metadataFile!.exists()) {
      if (await backupFile.exists()) {
        await backupFile.rename(_metadataFile!.path);
      } else if (await tempFile.exists()) {
        await tempFile.rename(_metadataFile!.path);
      }
    }

    if (await _metadataFile!.exists()) {
      if (await backupFile.exists()) {
        await backupFile.delete();
      }
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  Future<void> _persistMetadata() async {
    try {
      await _initializeDirectories();
      final imageJsonList =
          _savedImages.map((image) => image.toJson()).toList();
      final jsonString = jsonEncode(imageJsonList);
      final tempFile = File('${_metadataFile!.path}.tmp');
      final backupFile = File('${_metadataFile!.path}.bak');

      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      await tempFile.writeAsString(jsonString, flush: true);

      if (await backupFile.exists()) {
        await backupFile.delete();
      }

      final hadMetadata = await _metadataFile!.exists();
      if (hadMetadata) {
        await _metadataFile!.rename(backupFile.path);
      }

      try {
        await tempFile.rename(_metadataFile!.path);
      } catch (e) {
        if (!await _metadataFile!.exists() && await backupFile.exists()) {
          await backupFile.rename(_metadataFile!.path);
        }
        rethrow;
      }

      if (await backupFile.exists()) {
        try {
          await backupFile.delete();
        } catch (e) {
          AppLogger.warning('Failed to delete metadata backup: $e');
        }
      }

      AppLogger.debug('Metadata saved to: ${_metadataFile!.path}');
    } catch (e) {
      AppLogger.error('Error persisting metadata: $e');
      rethrow;
    }
  }

  Future<void> _cleanupOrphanedTemplateAssets(Set<String> validImageIds) async {
    try {
      if (_templateAssetDirectory == null) return;
      final files = await _templateAssetDirectory!.list().toList();
      for (final file in files) {
        if (file is! File) continue;
        final name = file.uri.pathSegments.last;
        final match = RegExp(r'^(\d+)_contact_profile\.png$').firstMatch(name);
        if (match != null && !validImageIds.contains(match.group(1))) {
          AppLogger.debug('Deleting orphaned template asset: ${file.path}');
          await _deleteImageFile(file);
        }
      }
    } catch (e) {
      AppLogger.error('Error cleaning up orphaned template assets: $e');
    }
  }

  Future<void> _cleanupOrphanedFiles() async {
    try {
      if (_imageDirectory == null) return;
      final files = await _imageDirectory!.list().toList();
      final validFilePaths = _savedImages.map((img) => img.filePath).toSet();
      for (final file in files) {
        if (file is File && !validFilePaths.contains(file.path)) {
          AppLogger.debug('Deleting orphaned file: ${file.path}');
          await _deleteImageFile(file);
        }
      }
    } catch (e) {
      AppLogger.error('Error cleaning up orphaned files: $e');
    }
  }
}
