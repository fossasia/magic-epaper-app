import 'package:flutter/material.dart';

class BadgeColorPicker extends StatelessWidget {
  const BadgeColorPicker({
    super.key,
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final color in colors)
          _Swatch(
            color: color,
            isSelected: color.toARGB32() == selected.toARGB32(),
            onTap: () => onSelected(color),
          ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final checkColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
            width: isSelected ? 3 : 1,
          ),
        ),
        child:
            isSelected ? Icon(Icons.check, size: 20, color: checkColor) : null,
      ),
    );
  }
}
