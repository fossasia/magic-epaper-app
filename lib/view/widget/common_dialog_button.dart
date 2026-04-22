import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';

enum DialogButtonVariant { primary, secondary, danger, warning }

class CommonDialogButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final DialogButtonVariant variant;
  final IconData? icon;

  const CommonDialogButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DialogButtonVariant.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12.0);
    final padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    switch (variant) {
      case DialogButtonVariant.primary:
        return icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: 18),
                label: Text(label),
                style: _getButtonStyle(
                    context, colorAccent, Colors.white, borderRadius, padding),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: _getButtonStyle(
                    context, colorAccent, Colors.white, borderRadius, padding),
                child: Text(label),
              );
      case DialogButtonVariant.secondary:
        return icon != null
            ? OutlinedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: 18),
                label: Text(label),
                style: _getOutlinedButtonStyle(context, borderRadius, padding),
              )
            : OutlinedButton(
                onPressed: onPressed,
                style: _getOutlinedButtonStyle(context, borderRadius, padding),
                child: Text(label),
              );
      case DialogButtonVariant.danger:
        return icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: 18),
                label: Text(label),
                style: _getButtonStyle(context, Colors.red.shade600,
                    Colors.white, borderRadius, padding),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: _getButtonStyle(context, Colors.red.shade600,
                    Colors.white, borderRadius, padding),
                child: Text(label),
              );
      case DialogButtonVariant.warning:
        return icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: 18),
                label: Text(label),
                style: _getButtonStyle(context, Colors.orange.shade600,
                    Colors.white, borderRadius, padding),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: _getButtonStyle(context, Colors.orange.shade600,
                    Colors.white, borderRadius, padding),
                child: Text(label),
              );
    }
  }

  ButtonStyle _getButtonStyle(
    BuildContext context,
    Color bgColor,
    Color fgColor,
    BorderRadius borderRadius,
    EdgeInsets padding,
  ) {
    return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      padding: padding,
      elevation: 0,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  ButtonStyle _getOutlinedButtonStyle(
    BuildContext context,
    BorderRadius borderRadius,
    EdgeInsets padding,
  ) {
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.grey.shade700,
      side: BorderSide(color: Colors.grey.shade300),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      padding: padding,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
