import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/weather_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

String weatherConditionLabel(AppLocalizations l10n, WeatherCondition c) {
  switch (c) {
    case WeatherCondition.clear:
      return l10n.weatherConditionClear;
    case WeatherCondition.mainlyClear:
      return l10n.weatherConditionMainlyClear;
    case WeatherCondition.partlyCloudy:
      return l10n.weatherConditionPartlyCloudy;
    case WeatherCondition.overcast:
      return l10n.weatherConditionOvercast;
    case WeatherCondition.fog:
      return l10n.weatherConditionFog;
    case WeatherCondition.drizzle:
      return l10n.weatherConditionDrizzle;
    case WeatherCondition.freezingRain:
      return l10n.weatherConditionFreezingRain;
    case WeatherCondition.rain:
      return l10n.weatherConditionRain;
    case WeatherCondition.rainShowers:
      return l10n.weatherConditionRainShowers;
    case WeatherCondition.snow:
      return l10n.weatherConditionSnow;
    case WeatherCondition.snowGrains:
      return l10n.weatherConditionSnowGrains;
    case WeatherCondition.snowShowers:
      return l10n.weatherConditionSnowShowers;
    case WeatherCondition.thunderstorm:
      return l10n.weatherConditionThunderstorm;
  }
}

class WeatherBadge extends StatelessWidget {
  final WeatherData data;
  final TemperatureUnit unit;

  const WeatherBadge({
    super.key,
    required this.data,
    this.unit = TemperatureUnit.celsius,
  });

  String get _unitLetter => unit == TemperatureUnit.fahrenheit ? 'F' : 'C';

  String _deg(double v) => '${v.round()}°';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final pad = math.min(w, h) * 0.08;
        final ch = h - 2 * pad;
        final landscape = w >= h * 1.15;

        return Container(
          width: w,
          height: h,
          color: colorWhite,
          padding: EdgeInsets.all(pad),
          child: landscape ? _landscape(ch) : _portrait(ch),
        );
      },
    );
  }

  Widget _icon(double size) => Icon(
        weatherIconFor(data.condition, data.isDay),
        size: size,
        color: colorBlack,
      );

  Widget _bigTemp(double numberSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _deg(data.temperatureIn(unit)),
          style: TextStyle(
            fontSize: numberSize,
            fontWeight: FontWeight.w800,
            color: colorBlack,
            height: 1,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: numberSize * 0.12, left: numberSize * 0.04),
          child: Text(
            _unitLetter,
            style: TextStyle(
              fontSize: numberSize * 0.32,
              fontWeight: FontWeight.w700,
              color: colorBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _city(double fontSize) => Text(
        data.cityName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: colorBlack,
        ),
      );

  Widget _conditionText(double fontSize) => Text(
        weatherConditionLabel(appLocalizations, data.condition),
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: colorBlack,
          height: 1.05,
        ),
      );

  List<Widget> _detailItems(double fontSize, {bool flexible = true}) {
    final l10n = appLocalizations;
    return <Widget>[
      _detail(
          Icons.thermostat, _deg(data.apparentTemperatureIn(unit)), fontSize,
          flexible: flexible),
      _detail(
          Icons.expand,
          '${_deg(data.tempMaxIn(unit))}/${_deg(data.tempMinIn(unit))}',
          fontSize,
          flexible: flexible),
      _detail(Icons.water_drop_outlined, '${data.humidity}%', fontSize,
          flexible: flexible),
      _detail(
          Icons.air, l10n.weatherWindValue(data.windSpeedKmh.round()), fontSize,
          flexible: flexible),
    ];
  }

  Widget _detailRow(double fontSize) {
    final items = _detailItems(fontSize, flexible: false);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(width: fontSize * 1.4),
            items[i],
          ],
        ],
      ),
    );
  }

  Widget _detailColumn(double fontSize, double gap) {
    final items = _detailItems(fontSize);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          items[i],
        ],
      ],
    );
  }

  Widget _detail(IconData icon, String text, double fontSize,
      {bool flexible = true}) {
    final label = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: colorBlack,
        height: 1.0,
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: fontSize * 1.05, color: colorBlack),
        SizedBox(width: fontSize * 0.18),
        flexible ? Flexible(child: label) : label,
      ],
    );
  }

  Widget _landscape(double ch) {
    final iconSize = ch * 0.34;
    final leftW = ch * 0.9;
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: leftW,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _icon(iconSize),
                    SizedBox(height: ch * 0.04),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _conditionText(ch * 0.13),
                    ),
                  ],
                ),
              ),
              SizedBox(width: ch * 0.08),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: _city(ch * 0.15),
                    ),
                    SizedBox(height: ch * 0.02),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: _bigTemp(ch * 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ch * 0.06),
        Divider(height: 1, thickness: 1, color: colorBlack),
        SizedBox(height: ch * 0.06),
        _detailRow(ch * 0.16),
      ],
    );
  }

  Widget _portrait(double ch) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: _city(ch * 0.07),
        ),
        SizedBox(height: ch * 0.02),
        _icon(ch * 0.26),
        SizedBox(height: ch * 0.01),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: _bigTemp(ch * 0.3),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: _conditionText(ch * 0.07),
        ),
        SizedBox(height: ch * 0.05),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ch * 0.06),
          child: _detailColumn(ch * 0.06, ch * 0.03),
        ),
      ],
    );
  }
}
