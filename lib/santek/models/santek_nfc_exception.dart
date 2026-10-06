class SantekNfcException implements Exception {
  final String code;
  final String message;

  const SantekNfcException(this.code, this.message);

  @override
  String toString() => message;
}
