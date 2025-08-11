import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/image_library/widgets/filter_chip_widget.dart';
import 'package:magicepaperapp/image_library/widgets/search_field_widget.dart';
import 'package:magicepaperapp/constants/color_constants.dart';

class SearchAndFilterWidget extends StatelessWidget {
  final TextEditingController searchController;
  final ImageLibraryProvider provider;

  const SearchAndFilterWidget({
    super.key,
    required this.searchController,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SearchFieldWidget(
            controller: searchController,
            onChanged: provider.updateSearchQuery,
            onClear: () {
              searchController.clear();
              provider.updateSearchQuery('');
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Filter: ',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChipWidget(
                        label: 'All',
                        value: 'all',
                        isSelected: provider.selectedSource == 'all',
                        onSelected: provider.updateSourceFilter,
                      ),
                      FilterChipWidget(
                        label: 'Imported',
                        value: 'imported',
                        isSelected: provider.selectedSource == 'imported',
                        onSelected: provider.updateSourceFilter,
                      ),
                      FilterChipWidget(
                        label: 'Editor',
                        value: 'editor',
                        isSelected: provider.selectedSource == 'editor',
                        onSelected: provider.updateSourceFilter,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
