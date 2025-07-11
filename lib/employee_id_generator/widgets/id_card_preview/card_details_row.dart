import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';

class CardDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const CardDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: colorBlack, fontSize: 10),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value.isNotEmpty ? value : StringConstants.notProvided,
              style: TextStyle(
                color: value.isNotEmpty ? colorBlack : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
