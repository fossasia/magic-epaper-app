import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/image_library/model/saved_image_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ImageLibraryProvider extends ChangeNotifier {
  List<SavedImage> _savedImages = [];
  List<SavedImage> get savedImages => _savedImages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedSource = 'all';
  String get selectedSource => _selectedSource;

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

  Future<void> loadSavedImages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedImagesJson = prefs.getStringList('saved_images') ?? [];

      _savedImages = savedImagesJson
          .map((json) => SavedImage.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      debugPrint('Error loading saved images: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveImage({
    required String name,
    required Uint8List imageData,
    required String source,
    Map<String, dynamic>? metadata,
  }) async {
    final savedImage = SavedImage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      imageData: imageData,
      createdAt: DateTime.now(),
      source: source,
      metadata: metadata,
    );

    _savedImages.add(savedImage);
    await _persistImages();
    notifyListeners();
  }

  Future<void> deleteImage(String id) async {
    _savedImages.removeWhere((image) => image.id == id);
    await _persistImages();
    notifyListeners();
  }

  Future<void> renameImage(String id, String newName) async {
    final index = _savedImages.indexWhere((image) => image.id == id);
    if (index != -1) {
      final oldImage = _savedImages[index];
      _savedImages[index] = SavedImage(
        id: oldImage.id,
        name: newName,
        imageData: oldImage.imageData,
        createdAt: oldImage.createdAt,
        source: oldImage.source,
        metadata: oldImage.metadata,
      );
      await _persistImages();
      notifyListeners();
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

  Future<void> _persistImages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedImagesJson =
          _savedImages.map((image) => jsonEncode(image.toJson())).toList();
      await prefs.setStringList('saved_images', savedImagesJson);
    } catch (e) {
      debugPrint('Error persisting images: $e');
    }
  }
}
