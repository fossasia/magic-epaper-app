import 'dart:typed_data';

class CardTemplateResult {
  final Uint8List png;
  final Map<String, dynamic>? metadata;

  const CardTemplateResult(this.png, {this.metadata});
}
