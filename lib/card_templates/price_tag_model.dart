import 'dart:io';

class PriceTagModel {
  final String productName;
  final String productDescription;
  final String price;
  final String currency;
  final String quantity;
  final String barcodeData;
  final File? productImage;

  PriceTagModel({
    required this.productName,
    this.productDescription = '',
    required this.price,
    required this.currency,
    required this.quantity,
    required this.barcodeData,
    this.productImage,
  });
}
