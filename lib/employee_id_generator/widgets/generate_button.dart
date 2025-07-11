import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';

class GenerateButton extends StatelessWidget {
  final bool isGenerating;
  final VoidCallback? onPressed;

  const GenerateButton({
    super.key,
    required this.isGenerating,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: TextButton(
        onPressed: isGenerating ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isGenerating ? Colors.grey : colorAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white, width: 1),
          ),
        ),
        child: isGenerating
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(StringConstants.generateButtonLabel),
      ),
    );
  }
}
