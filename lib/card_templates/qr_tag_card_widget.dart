import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/qr_tag_badge.dart';
import 'package:magicepaperapp/card_templates/qr_tag_model.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/theme/colors.dart';

class QrTagCardWidget extends StatelessWidget {
  final QrTagModel data;
  final int width;
  final int height;

  const QrTagCardWidget({
    super.key,
    required this.data,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            border: Border.all(color: grey300),
            boxShadow: [
              BoxShadow(
                color: colorBlack.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: width / height,
            child: QrTagBadge(data: data, isPreview: true),
          ),
        ),
      ),
    );
  }
}
