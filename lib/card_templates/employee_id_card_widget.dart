import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magic_epaper_app/card_templates/employee_id_model.dart';

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
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            // Profile image
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
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child:
                        const Icon(Icons.person, size: 48, color: Colors.grey),
                  ),
            const SizedBox(height: 8),
            // Company Name
            if (data.companyName.isNotEmpty)
              Text(
                data.companyName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 4),
            // Name
            if (data.name.isNotEmpty)
              Text(
                'Name: ${data.name}',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            if (data.name.isNotEmpty)
              Text(
                'Name: ${data.name}',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            // Position
            if (data.position.isNotEmpty)
              Text(
                'Position: ${data.position}',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            // Division
            if (data.division.isNotEmpty)
              Text(
                'Division: ${data.division}',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            // ID
            if (data.idNumber.isNotEmpty)
              Text(
                'ID: ${data.idNumber}',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 8),
            // QR Code
            if (data.qrData.isNotEmpty)
              BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: data.qrData,
                width: 40,
                height: 40,
              ),
          ],
        ),
      ),
    );
  }
}
