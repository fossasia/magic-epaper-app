import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/card_templates/employee_id_model.dart';

import 'package:magicepaperapp/constants/string_constants.dart';

class EmployeeIdCardWidget extends StatelessWidget {
  final EmployeeIdModel data;

  const EmployeeIdCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 144,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              data.profileImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.file(
                        data.profileImage!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
              const SizedBox(height: 8),
              Text(
                data.companyName.isNotEmpty
                    ? data.companyName
                    : StringConstants.defaultCompanyName,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: data.companyName.isEmpty
                      ? Colors.grey[400]
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoRow(StringConstants.nameLabel, data.name),
                    _buildInfoRow(StringConstants.positionLabel, data.position),
                    _buildInfoRow(StringConstants.divisionLabel, data.division),
                    _buildInfoRow(StringConstants.idLabel, data.idNumber),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 40,
                height: 40,
                child: data.qrData.isNotEmpty
                    ? BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        data: data.qrData,
                        width: 40,
                        height: 40,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                        child: Icon(
                          Icons.qr_code,
                          color: Colors.grey[400],
                          size: 24,
                        ),
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
        : '$label: ${StringConstants.emptyFieldPlaceholder}';
    final isEmpty = value.isEmpty;

    return Text(
      displayText,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 9,
        color: isEmpty ? Colors.grey[400] : Colors.black,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
