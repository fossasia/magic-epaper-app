import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/price_tag_model.dart';

class PriceTagCardWidget extends StatelessWidget {
  final PriceTagModel data;

  const PriceTagCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 296,
        height: 144,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Expanded(
                    flex: 2,
                    child: data.productImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              File(data.productImage!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(Icons.image_outlined,
                                size: 40, color: Colors.grey),
                          ),
                  ),
                  const SizedBox(width: 8),
                  // Product Name and Quantity
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data.productName.isNotEmpty)
                          Text(
                            data.productName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (data.quantity.isNotEmpty)
                          Text(
                            data.quantity,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  // Barcode
                  Expanded(
                    flex: 3,
                    child: data.barcodeData.isNotEmpty
                        ? BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: data.barcodeData,
                            drawText: false,
                            style: const TextStyle(color: Colors.black),
                          )
                        : Container(),
                  ),
                  const SizedBox(width: 8),
                  // Price
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${data.currency} ${data.price}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
