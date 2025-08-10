import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final ValueChanged<String> onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(value),
        selectedColor: colorAccent.withOpacity(0.2),
        checkmarkColor: colorAccent,
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
