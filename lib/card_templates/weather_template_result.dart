import 'dart:typed_data';

class WeatherTemplateResult {
  final Uint8List png;
  final Map<String, dynamic> data;

  const WeatherTemplateResult(this.png, this.data);
}
