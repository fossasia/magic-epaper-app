import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'package:magic_epaper_app/constants.dart';

// Main list widget - now highly performant
class ImageList extends StatelessWidget {
  final List<Uint8List> processedPngs; // Takes pre-processed image data
  final Epd epd;
  final Function(int) onFilterSelected;
  final int selectedIndex;

  const ImageList({
    super.key,
    required this.processedPngs,
    required this.epd,
    required this.onFilterSelected,
    required this.selectedIndex,
  });

  String _getFilterNameByIndex(int index) {
    const Map<Function, String> filterMap = {
      ImageProcessing.bwFloydSteinbergDither: 'Floyd-Steinberg',
      ImageProcessing.bwFalseFloydSteinbergDither: 'False Floyd-Steinberg',
      ImageProcessing.bwStuckiDither: 'Stucki',
      ImageProcessing.bwAtkinsonDither: 'Atkinson',
      ImageProcessing.bwThreshold: 'Threshold',
      ImageProcessing.bwHalftoneDither: 'Halftone',
      ImageProcessing.bwrHalftone: 'Color Halftone',
      ImageProcessing.bwrFloydSteinbergDither: 'BWR Floyd-Steinberg',
      ImageProcessing.bwrFalseFloydSteinbergDither: 'BWR False Floyd-Steinberg',
      ImageProcessing.bwrStuckiDither: 'BWR Stucki',
      ImageProcessing.bwrTriColorAtkinsonDither: 'BWR Atkinson',
      ImageProcessing.bwrThreshold: 'BWR Threshold',
    };
    var methods = epd.processingMethods;
    if (index < 0 || index >= methods.length) return "Unknown";
    return filterMap[methods[index]] ?? "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Preview Widget
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              const Text(
                "Preview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: MemoryImage(processedPngs[selectedIndex]),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(indent: 20, endIndent: 20, height: 24),
        // The Performant List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
            itemCount: processedPngs.length,
            itemBuilder: (context, index) {
              return FilterCard(
                key: ValueKey(index), // Use index for the key
                imageData: processedPngs[index],
                filterName: _getFilterNameByIndex(index),
                isSelected: index == selectedIndex,
                onTap: () => onFilterSelected(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

// The individual list item - it's a stateless widget for max performance
class FilterCard extends StatelessWidget {
  final Uint8List imageData;
  final String filterName;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterCard({
    super.key,
    required this.imageData,
    required this.filterName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorAccent : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorAccent.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                flex: 4, // Give more space to the name
                child: Text(
                  filterName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                    color: isSelected ? colorAccent : Colors.black
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 5,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: MemoryImage(imageData),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}