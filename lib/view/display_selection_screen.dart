import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magic_epaper_app/provider/display_provider.dart';
import 'package:magic_epaper_app/view/widget/display_card.dart';
import 'package:magic_epaper_app/view/widget/filter_chip_option.dart';
import 'package:magic_epaper_app/view/image_editor.dart';
import 'package:magic_epaper_app/constants.dart';

class DisplaySelectionScreen extends StatelessWidget {
  const DisplaySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colorAccent,
        elevation: 0, // Remove shadow
        title: const Padding(
          padding: EdgeInsets.fromLTRB(5, 16, 16, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Magic ePaper',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Select your ePaper display type',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 85, // Adjust height to accommodate both texts
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 14, 16.0, 16.0),
          child: Column(
            children: [
              // Filter chips
              _buildFilterChips(),
              const SizedBox(height: 16),

              // Display cards grid
              Expanded(
                child: _buildDisplayGrid(),
              ),

              // Continue button
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Build filter chips section
  Widget _buildFilterChips() {
    return Consumer<DisplayProvider>(
      builder: (context, displayProvider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: displayProvider.filterOptions.map((filter) {
              final isSelected = filter == displayProvider.activeFilter;
              return FilterChipOption(
                label: filter,
                isSelected: isSelected,
                onSelected: () => displayProvider.setFilter(filter),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Build display cards grid
  Widget _buildDisplayGrid() {
    return Consumer<DisplayProvider>(
      builder: (context, displayProvider, child) {
        final displays = displayProvider.filteredDisplays;

        if (displays.isEmpty) {
          return const Center(
            child: Text(
              'No displays match the selected filter',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: displays.length,
          itemBuilder: (context, index) {
            final display = displays[index];
            final isSelected = index == displayProvider.selectedDisplayIndex;

            return DisplayCard(
              display: display,
              isSelected: isSelected,
              onTap: () => displayProvider.selectDisplay(index),
            );
          },
        );
      },
    );
  }

  // Build continue button
  Widget _buildContinueButton(BuildContext context) {
    return Consumer<DisplayProvider>(
      builder: (context, displayProvider, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: displayProvider.hasSelection
                ? () {
                    // Navigate to image editor with selected display
                    final selectedDisplay = displayProvider.selectedDisplay!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditor(
                          epd: selectedDisplay.epd,
                        ),
                      ),
                    );
                  }
                : null,
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
