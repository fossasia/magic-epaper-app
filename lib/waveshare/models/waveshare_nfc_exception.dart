class WaveshareNfcException implements Exception {
  final String code;
  final String message;

  const WaveshareNfcException(this.code, this.message);

  @override
  String toString() => message;
}
