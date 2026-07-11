import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class TemplateInfoField {
  final String prefix;
  final String value;
  const TemplateInfoField(this.prefix, this.value);
}

class TemplateCardPreview extends StatelessWidget {
  final String title;
  final String titlePlaceholder;
  final List<TemplateInfoField> fields;
  final String qrData;
  final File? photo;

  const TemplateCardPreview({
    super.key,
    required this.title,
    required this.titlePlaceholder,
    required this.fields,
    required this.qrData,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasTitle = title.trim().isNotEmpty;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimens.radiusXl),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(Dimens.spacingL),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatar(),
                  const SizedBox(height: Dimens.spacingMd),
                  _buildQr(),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hasTitle ? title : titlePlaceholder,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                        color: hasTitle ? Colors.black : Colors.grey.shade400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimens.spacingS),
                    ...fields.map(_buildInfoRow),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: photo != null
          ? Image.file(photo!, fit: BoxFit.cover)
          : Icon(Icons.person_outline, size: 34, color: Colors.grey.shade400),
    );
  }

  Widget _buildQr() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.radiusS),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: qrData.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(3),
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: qrData,
                drawText: false,
              ),
            )
          : Icon(Icons.qr_code_2,
              size: Dimens.iconSizeXl, color: Colors.grey.shade400),
    );
  }

  Widget _buildInfoRow(TemplateInfoField field) {
    final bool hasValue = field.value.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacingXs),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: field.prefix,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: hasValue
                  ? field.value
                  : appLocalizations.emptyFieldPlaceholder,
              style: TextStyle(
                fontSize: 12.5,
                color: hasValue ? Colors.black : Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
