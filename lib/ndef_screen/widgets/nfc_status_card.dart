import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/constants/string_constants.dart';
import 'package:magicepaperapp/ndef_screen/services/nfc_availability_service.dart';

class NFCStatusCard extends StatelessWidget {
  final NFCAvailability availability;
  final VoidCallback onRefresh;

  const NFCStatusCard({
    super.key,
    required this.availability,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringConstants.nfcStatus,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: onRefresh,
                  tooltip: StringConstants.refreshNfcStatus,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  NFCAvailabilityService.getAvailabilityIcon(availability),
                  color:
                      NFCAvailabilityService.getAvailabilityColor(availability),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    NFCAvailabilityService.getAvailabilityString(availability),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: NFCAvailabilityService.getAvailabilityColor(
                          availability),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
