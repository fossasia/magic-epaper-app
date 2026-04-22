import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';

class CommonDialogDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;
  final String? hintText;

  const CommonDialogDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.labelText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: colorAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        floatingLabelStyle: const TextStyle(color: colorAccent),
      ),
      isExpanded: true,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
    );
  }
}
