import 'dart:io';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'event_badge_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class EventBadgeCardWidget extends StatelessWidget {
  final EventBadgeModel data;

  const EventBadgeCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: data.profileImage != null
                          ? Colors.transparent
                          : Colors.grey.shade50,
                    ),
                    child: data.profileImage != null
                        ? ClipOval(
                            child: Image.file(
                              File(data.profileImage!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 32,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appLocalizations.profileImage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: data.qrData.isNotEmpty
                          ? Colors.transparent
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                      border: data.qrData.isNotEmpty
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: data.qrData.isNotEmpty
                        ? BarcodeWidget(
                            barcode: Barcode.qrCode(),
                            data: data.qrData,
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.all(2),
                            backgroundColor: Colors.white,
                          )
                        : Icon(
                            Icons.qr_code,
                            color: Colors.grey.shade400,
                            size: 24,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.eventName.isEmpty
                        ? appLocalizations.eventName
                        : data.eventName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.purple.shade700,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.attendeeName.isEmpty ? '-' : data.attendeeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.badge_outlined,
                          size: 10, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        data.role.isEmpty ? '-' : data.role,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.business_outlined,
                          size: 10, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        data.organization.isEmpty ? '-' : data.organization,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '\\',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
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
