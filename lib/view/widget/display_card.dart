import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/color_util.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/epd.dart';
import 'package:magicepaperapp/util/epd/waveshare_nfc_display.dart';
import 'package:magicepaperapp/view/widget/color_dot.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class DisplayCard extends StatelessWidget {
  final DisplayDevice display;
  final bool isSelected;
  final VoidCallback onTap;

  final double? width;
  final bool fill;

  static const double _referenceWidth = 300.0;

  const DisplayCard.fill({
    super.key,
    required this.display,
    required this.isSelected,
    required this.onTap,
  })  : width = null,
        fill = true;

  const DisplayCard.scaled({
    super.key,
    required this.display,
    required this.isSelected,
    required this.onTap,
    required this.width,
  }) : fill = false;

  @override
  Widget build(BuildContext context) {
    final String driverText;
    final currentDisplay = display;

    if (currentDisplay is Epd) {
      driverText = currentDisplay.driverName;
    } else {
      driverText = 'Waveshare SDK';
    }

    final chips = display.displayChips;

    final double scale =
        fill ? 1.0 : (width! / _referenceWidth).clamp(0.5, 1.0);

    final Widget imageArea = ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(11 * scale),
        topRight: Radius.circular(11 * scale),
      ),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingXs * scale),
          child: Image.asset(
            display.imgPath,
            fit: BoxFit.contain,
            height: fill ? 160 : null,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.display_settings,
                  size: 60 * scale,
                  color: Colors.grey.shade400,
                ),
              );
            },
          ),
        ),
      ),
    );

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.redAccent,
      borderRadius: BorderRadius.circular(Dimens.radiusXl * scale),
      splashColor: Colors.redAccent.withAlpha(51),
      child: Card(
        color: Colors.white,
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusXl * scale),
          side: BorderSide(
            color: isSelected ? colorPrimary : Colors.grey.shade300,
            width:
                isSelected ? Dimens.borderWidthThick : Dimens.borderWidthThin,
          ),
        ),
        child: Column(
          mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fill
                ? Expanded(child: imageArea)
                : SizedBox(
                    height: 120 * scale,
                    width: double.infinity,
                    child: imageArea,
                  ),
            Padding(
              padding: EdgeInsets.all(Dimens.spacingM * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    display.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Dimens.fontSizeL * scale,
                    ),
                  ),
                  SizedBox(height: Dimens.spacingS * scale),
                  if (chips != null && chips.isNotEmpty) ...[
                    Wrap(
                      spacing: Dimens.spacingXs * scale,
                      runSpacing: Dimens.spacingXs * scale,
                      children:
                          chips.map((chip) => _buildChip(chip, scale)).toList(),
                    ),
                    SizedBox(height: Dimens.spacingS * scale),
                  ],
                  Row(
                    children: display.colors
                        .map(
                            (color) => ColorDot(color: color, size: 12 * scale))
                        .toList(),
                  ),
                  SizedBox(height: Dimens.spacingXs * scale),
                  Text(
                    display.colors
                        .map(ColorUtils.getColorDisplayName)
                        .join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimens.fontSizeXs * scale,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: Dimens.spacingS * scale),
                  if (display is WaveshareNfcDisplay) ...[
                    _buildSpecRow(
                        appLocalizations.skuSpecLabel, display.modelId, scale),
                    _buildSpecRow(appLocalizations.resolutionSpecLabel,
                        '${display.width} × ${display.height}', scale),
                    _buildSpecRow(
                        appLocalizations.sdkSpecLabel, driverText, scale),
                  ] else ...[
                    _buildSpecRow(appLocalizations.displaySpecLabel,
                        display.modelId, scale),
                    _buildSpecRow(appLocalizations.resolutionSpecLabel,
                        '${display.width} × ${display.height}', scale),
                    _buildSpecRow(appLocalizations.displayDriverSpecLabel,
                        driverText, scale),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, double scale) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacingS * scale, vertical: 3 * scale),
      decoration: BoxDecoration(
        color: colorPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimens.radiusXl * scale),
        border: Border.all(
          color: colorPrimary.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 7 * scale,
          fontWeight: FontWeight.w600,
          color: colorPrimary,
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, double scale) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.spacingXs * scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: Dimens.fontSizeXs * scale, color: Colors.grey),
            ),
          ),
          SizedBox(width: Dimens.spacingS * scale),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: Dimens.fontSizeXs * scale,
                  fontWeight: FontWeight.w500),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
