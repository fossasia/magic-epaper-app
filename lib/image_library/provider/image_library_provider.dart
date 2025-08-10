import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageLibraryProvider extends ChangeNotifier {
  List<SavedImage> _savedImages = [];
  List<SavedImage> get savedImages => _savedImages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedSource = 'all';
  String get selectedSource => _selectedSource;

  Directory? _magicEpaperDirectory;
  Directory? _imageDirectory;
  File? _metadataFile;
  bool _isInitialized = false;

  List<SavedImage> get filteredImages {
    var filtered = _savedImages.where((image) {
      final matchesSearch =
          image.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSource =
          _selectedSource == 'all' || image.source == _selectedSource;
      return matchesSearch && matchesSource;
    }).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  Future<void> _initializeDirectories() async {
    if (_magicEpaperDirectory == null) {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        final storageRoot = Directory('/storage/emulated/0');
        _magicEpaperDirectory = Directory('${storageRoot.path}/MagicEpaper');
      } else {
        final fallbackDir = await getApplicationDocumentsDirectory();
        _magicEpaperDirectory = Directory('${fallbackDir.path}/MagicEpaper');
      }
      if (!await _magicEpaperDirectory!.exists()) {
        await _magicEpaperDirectory!.create(recursive: true);
      }
      _imageDirectory = Directory('${_magicEpaperDirectory!.path}/images');
      if (!await _imageDirectory!.exists()) {
        await _imageDirectory!.create(recursive: true);
      }
      _metadataFile =
          File('${_magicEpaperDirectory!.path}/images_metadata.json');
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await loadSavedImages();
    }
  }

  Future<void> loadSavedImages() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _initializeDirectories();
      _savedImages = [];
      if (await _metadataFile!.exists()) {
        final jsonString = await _metadataFile!.readAsString();
        if (jsonString.isNotEmpty) {
          try {
            final List<dynamic> jsonList = jsonDecode(jsonString);
            for (var json in jsonList) {
              try {
                final image = SavedImage.fromJson(json);
                if (await image.fileExists()) {
                  _savedImages.add(image);
                } else {
                  debugPrint('Image file not found: ${image.filePath}');
                }
              } catch (e) {
                debugPrint('Error parsing individual image metadata: $e');
              }
            }
          } catch (e) {
            debugPrint('Error parsing JSON metadata file: $e');
          }
        }
      }
      if (_savedImages.isNotEmpty) {
        const encoder = JsonEncoder.withIndent('  ');
        final imageJsonList = _savedImages.map((img) => img.toJson()).toList();
        final prettyJson = encoder.convert(imageJsonList);
        debugPrint('Loaded image metadata (JSON):\n$prettyJson');
      } else {
        debugPrint('No saved images to print.');
      }
      await _cleanupOrphanedFiles();
      debugPrint('Loaded ${_savedImages.length} images successfully');
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error loading saved images: $e');
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
          '${imageId}_${name.replaceAll(RegExp(r'[^\w\s-]'), '')}.jpg';
      final filePath = '${_imageDirectory!.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(imageData);
      final savedImage = SavedImage(
        id: imageId,
        name: name,
        filePath: filePath,
        createdAt: DateTime.now(),
        source: source,
        metadata: metadata,
      );
      _savedImages.add(savedImage);
      await _persistMetadata();
      debugPrint('Successfully saved image: $name (${imageData.length} bytes)');
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving image: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(String id) async {
    try {
      await _ensureInitialized();
      final imageIndex = _savedImages.indexWhere((image) => image.id == id);
      if (imageIndex == -1) return;
      final image = _savedImages[imageIndex];
      final file = File(image.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      _savedImages.removeAt(imageIndex);
      await _persistMetadata();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting image: $e');
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
      debugPrint('Error renaming image: $e');
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

  Future<void> _persistMetadata() async {
    try {
      await _initializeDirectories();
      final imageJsonList =
          _savedImages.map((image) => image.toJson()).toList();
      final jsonString = jsonEncode(imageJsonList);
      await _metadataFile!.writeAsString(jsonString);
      final fileSize = await _metadataFile!.length();
      debugPrint('Metadata file size: $fileSize bytes');
      debugPrint('Metadata saved to: ${_metadataFile!.path}');
    } catch (e) {
      debugPrint('Error persisting metadata: $e');
      rethrow;
    }
  }

  Future<void> _cleanupOrphanedFiles() async {
    try {
      if (_imageDirectory == null) return;
      final files = await _imageDirectory!.list().toList();
      final validFilePaths = _savedImages.map((img) => img.filePath).toSet();
      for (final file in files) {
        if (file is File && !validFilePaths.contains(file.path)) {
          debugPrint('Deleting orphaned file: ${file.path}');
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up orphaned files: $e');
    }
  }
}
