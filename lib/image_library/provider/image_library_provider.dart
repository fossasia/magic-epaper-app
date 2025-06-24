import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/image_library/model/saved_image_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Directory? _imageDirectory;
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

  Future<void> _initializeDirectory() async {
    if (_imageDirectory == null) {
      final appDir = await getApplicationDocumentsDirectory();
      _imageDirectory = Directory('${appDir.path}/saved_images');
      if (!await _imageDirectory!.exists()) {
        await _imageDirectory!.create(recursive: true);
      }
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
      await _initializeDirectory();
      final prefs = await SharedPreferences.getInstance();
      final savedImagesJson =
          prefs.getStringList('saved_images_metadata') ?? [];
      _savedImages = [];
      for (String json in savedImagesJson) {
        try {
          final image = SavedImage.fromJson(jsonDecode(json));
          if (await image.fileExists()) {
            _savedImages.add(image);
          } else {
            debugPrint('Image file not found: ${image.filePath}');
          }
        } catch (e) {
          debugPrint('Error parsing image metadata: $e');
        }
      }
      if (_savedImages.isNotEmpty) {
        final encoder = JsonEncoder.withIndent('  ');
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
      await _initializeDirectory();
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
      final prefs = await SharedPreferences.getInstance();
      final metadataJson =
          _savedImages.map((image) => jsonEncode(image.toJson())).toList();
      await prefs.setStringList('saved_images_metadata', metadataJson);
      final totalSize = metadataJson.join().length;
      debugPrint('Metadata size: ${totalSize} bytes');
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
