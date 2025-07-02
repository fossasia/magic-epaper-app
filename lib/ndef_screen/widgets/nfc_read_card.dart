import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';

class NFCReadCard extends StatelessWidget {
  final bool isReading;
  final String result;
  final VoidCallback onRead;
  final VoidCallback onVerify;
  final VoidCallback onClear;
  final bool isClearing;

  const NFCReadCard({
    super.key,
    required this.isReading,
    required this.result,
    required this.onRead,
    required this.onVerify,
    required this.onClear,
    required this.isClearing,
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
            Text(
              StringConstants.readNdefTags,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isReading ? null : onRead,
                    icon: isReading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.nfc),
                    label: Text(isReading ? StringConstants.reading : StringConstants.readNfcTag),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onVerify,
                  icon: const Icon(Icons.search),
                  label: const Text(StringConstants.verify),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isClearing ? null : onClear,
                icon: isClearing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.delete_forever),
                label: Text(isClearing ? StringConstants.clearing : StringConstants.clearNfcTag),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            if (result.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontFamily: StringConstants.monospaceFontFamily,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}