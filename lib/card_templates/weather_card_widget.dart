import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/weather_badge.dart';
import 'package:magicepaperapp/card_templates/weather_model.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class WeatherCardWidget extends StatelessWidget {
  final WeatherData? data;
  final TemperatureUnit unit;
  final int width;
  final int height;

  const WeatherCardWidget({
    super.key,
    required this.data,
    required this.unit,
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
            child: data == null
                ? _placeholder()
                : WeatherBadge(data: data!, unit: unit),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: colorWhite,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimens.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_outlined, size: 40, color: grey400),
          const SizedBox(height: Dimens.spacingS),
          Text(
            appLocalizations.weatherPreviewPlaceholder,
            textAlign: TextAlign.center,
            style: TextStyle(color: grey500, fontSize: Dimens.fontSizeM),
          ),
        ],
      ),
    );
  }
}
