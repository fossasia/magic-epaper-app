import 'dart:io';
import 'package:magicepaperapp/theme/colors.dart';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/price_tag_model.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class PriceTagCardWidget extends StatelessWidget {
  final PriceTagModel data;

  const PriceTagCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 180,
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(Dimens.radiusXl),
          border: Border.all(color: grey300, width: 1),
          boxShadow: [
            BoxShadow(
              color: colorBlack.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(Dimens.spacingS),
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
                            : grey50,
                        borderRadius: BorderRadius.circular(Dimens.radiusM),
                        border: Border.all(
                          color: data.productImage != null
                              ? Colors.transparent
                              : grey300,
                          width: 1,
                        ),
                      ),
                      child: data.productImage != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Dimens.radiusM),
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
                                  color: grey400,
                                ),
                                const SizedBox(height: Dimens.spacingXs),
                                Text(
                                  appLocalizations.productImage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Dimens.fontSizeXs,
                                    color: grey500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: Dimens.spacingS),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimens.spacingXs),
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
                                      fontSize: Dimens.fontSizeL,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      appLocalizations.productName,
                                      style: TextStyle(
                                        fontSize: Dimens.fontSizeM,
                                        color: grey400,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: Dimens.spacingSm),
                          data.productDescription.isNotEmpty
                              ? Text(
                                  data.productDescription,
                                  style: const TextStyle(
                                    fontSize: Dimens.fontSizeS,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  'Product Description',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: grey400,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimens.spacingS),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            data.barcodeData.isNotEmpty ? colorWhite : grey50,
                        borderRadius: BorderRadius.circular(Dimens.radiusS),
                        border: Border.all(
                          color: data.barcodeData.isNotEmpty
                              ? Colors.transparent
                              : grey300,
                          width: 1,
                        ),
                      ),
                      child: data.barcodeData.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(Dimens.spacingXxs),
                              child: BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: data.barcodeData,
                                drawText: false,
                                style: const TextStyle(color: colorBlack),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner_outlined,
                                  size: Dimens.iconSizeM,
                                  color: grey400,
                                ),
                                const SizedBox(height: Dimens.spacingXxs),
                                Text(
                                  appLocalizations.barcode,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: grey500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: Dimens.spacingS),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.spacingSm),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (data.currency.isNotEmpty || data.price.isNotEmpty)
                              ? Text(
                                  '${data.currency.isNotEmpty ? data.currency : appLocalizations.defaultCurrency}${data.price.isNotEmpty ? ' ${data.price}' : ' ${appLocalizations.defaultPrice}'}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      size: 18,
                                      color: grey400,
                                    ),
                                    const SizedBox(width: Dimens.spacingSm),
                                    Text(
                                      appLocalizations.price,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: grey500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: Dimens.spacingSm),
                          data.quantity.isNotEmpty
                              ? Text(
                                  data.quantity,
                                  style: const TextStyle(
                                    fontSize: Dimens.fontSizeS,
                                    color: grey500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : Text(
                                  appLocalizations.sizeQuantity,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: grey400,
                                    fontWeight: FontWeight.w400,
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
