import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_epaper_app/model/display_model.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03bw.dart';

class DisplayProvider extends ChangeNotifier {
  // Filter options
  String _activeFilter = 'All Displays';
  int _selectedDisplayIndex = -1; // -1 means no selection

  // Getters
  String get activeFilter => _activeFilter;
  int get selectedDisplayIndex => _selectedDisplayIndex;
  bool get hasSelection => _selectedDisplayIndex != -1;
  DisplayModel? get selectedDisplay =>
      hasSelection ? filteredDisplays[_selectedDisplayIndex] : null;

  // All filter options
  final List<String> filterOptions = [
    'All Displays',
    'Color',
    'Black & White',
    'HD',
  ];

  // List of all available displays
  List<DisplayModel> allDisplays = [];

  // Constructor - Initialize by loading from JSON
  DisplayProvider() {
    loadDisplaysFromJson();
  }

  // Load displays from JSON file
  Future<void> loadDisplaysFromJson() async {
    try {
      // Load the JSON file from the assets
      final String jsonString =
          await rootBundle.loadString('assets/displays.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Clear the existing displays
      allDisplays = [];

      // Parse the JSON data
      for (var displayData in jsonData['displays']) {
        // Convert colors from strings to Color objects
        List<Color> colors = [];
        for (var colorName in displayData['colors']) {
          switch (colorName) {
            case 'black':
              colors.add(Colors.black);
              break;
            case 'white':
              colors.add(Colors.white);
              break;
            case 'red':
              colors.add(Colors.red);
              break;
            case 'yellow':
              colors.add(Colors.yellow);
              break;
          }
        }

        // Determine which EPD to use based on the class name
        var epd = _getEpdForClassName(displayData['epdClass']);

        // Create a DisplayModel from the JSON data
        final display = DisplayModel(
          id: displayData['id'],
          name: displayData['name'],
          size: displayData['size'],
          ModelName: displayData['model'],
          width: displayData['resolution'][0],
          height: displayData['resolution'][1],
          colors: colors,
          driver: displayData['driver'],
          imagePath: displayData['imagePath'],
          epd: epd,
        );

        allDisplays.add(display);
      }

      // Notify listeners that the data has changed
      notifyListeners();
    } catch (e) {
      print('Error loading displays from JSON: $e');
    }
  }

  // Helper method to get the appropriate EPD based on class name
  dynamic _getEpdForClassName(String className) {
    switch (className) {
      case 'Gdey037z03':
        return Gdey037z03();
      case 'Gdey037z03BW':
        return Gdey037z03BW();
      default:
        return Gdey037z03(); // Default fallback
    }
  }

  // Get filtered displays based on the active filter
  List<DisplayModel> get filteredDisplays {
    switch (_activeFilter) {
      case 'HD':
        return allDisplays.where((display) => display.isHd).toList();
      case 'Color':
        return allDisplays.where((display) => display.isColor).toList();
      case 'Black & White':
        return allDisplays.where((display) => !display.isColor).toList();
      case 'All Displays':
      default:
        return allDisplays;
    }
  }

  // Set the active filter
  void setFilter(String filter) {
    if (_activeFilter != filter) {
      _activeFilter = filter;
      // Reset selection when filter changes
      _selectedDisplayIndex = -1;
      notifyListeners();
    }
  }

  // Select a display
  void selectDisplay(int index) {
    if (index >= 0 && index < filteredDisplays.length) {
      _selectedDisplayIndex = index;
      notifyListeners();
    }
  }

  // Clear selection
  void clearSelection() {
    _selectedDisplayIndex = -1;
    notifyListeners();
  }
}
