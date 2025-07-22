import 'dart:io';

/// Data model representing information required for a shopping price tag.
class PriceTagModel {
  final String productName;
  final String price; // Keeping as string to allow formatted text e.g. 199.99
  final String currency;
  final String quantity; // e.g. "750 ml"
  final String barcodeData;
  final File? productImage;

  PriceTagModel({
    required this.productName,
    required this.price,
    required this.currency,
    required this.quantity,
    required this.barcodeData,
    this.productImage,
  });
}
