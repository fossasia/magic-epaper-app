import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/price_tag_model.dart';
import 'package:magicepaperapp/constants/string_constants.dart';

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
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: data.productImage != null
                            ? Colors.transparent
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: data.productImage != null
                              ? Colors.transparent
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
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
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 28,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  StringConstants.productImage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(minHeight: 40),
                            child: data.productName.isNotEmpty
                                ? Text(
                                    data.productName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      StringConstants.productName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            constraints: const BoxConstraints(minHeight: 18),
                            child: data.quantity.isNotEmpty
                                ? Text(
                                    data.quantity,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    StringConstants.sizeQuantity,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                          ),
                        ],
                      ),
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
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: data.barcodeData.isNotEmpty
                            ? Colors.white
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: data.barcodeData.isNotEmpty
                              ? Colors.transparent
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: data.barcodeData.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(2),
                              child: BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: data.barcodeData,
                                drawText: false,
                                style: const TextStyle(color: Colors.black),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner_outlined,
                                  size: 20,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  StringConstants.barcode,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            (data.currency.isNotEmpty || data.price.isNotEmpty)
                                ? Colors.red.shade50
                                : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: (data.currency.isNotEmpty ||
                                  data.price.isNotEmpty)
                              ? Colors.red.shade200
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: (data.currency.isNotEmpty || data.price.isNotEmpty)
                          ? Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${data.currency.isNotEmpty ? data.currency : StringConstants.defaultCurrency}${data.price.isNotEmpty ? ' ${data.price}' : StringConstants.defaultPrice}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 20,
                                  color: Colors.grey.shade400,
                                ),
                                Text(
                                  StringConstants.price,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
