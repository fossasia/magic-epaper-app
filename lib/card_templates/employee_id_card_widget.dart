import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/card_templates/employee_id_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class EmployeeIdCardWidget extends StatelessWidget {
  final EmployeeIdModel data;

  const EmployeeIdCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  data.profileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.file(
                            data.profileImage!,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            size: 36,
                            color: Colors.grey,
                          ),
                        ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: data.qrData.isNotEmpty
                        ? BarcodeWidget(
                            barcode: Barcode.qrCode(),
                            data: data.qrData,
                            width: 64,
                            height: 64,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                            child: Icon(
                              Icons.qr_code,
                              color: Colors.grey[400],
                              size: 28,
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.companyName.isNotEmpty
                          ? data.companyName
                          : appLocalizations.defaultCompanyName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: data.companyName.isEmpty
                            ? Colors.grey[400]
                            : Colors.black,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(appLocalizations.nameLabel, data.name),
                    _buildInfoRow(
                        appLocalizations.positionLabel, data.position),
                    _buildInfoRow(
                        appLocalizations.divisionLabel, data.division),
                    _buildInfoRow(appLocalizations.idLabel, data.idNumber),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final displayText = value.isNotEmpty
        ? '$label: $value'
        : '$label: ${appLocalizations.emptyFieldPlaceholder}';
    final isEmpty = value.isEmpty;

    return Text(
      displayText,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: isEmpty ? Colors.grey[400] : Colors.black,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
