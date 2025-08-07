import 'package:flutter/material.dart';
import 'package:magic_epaper_app/ndef_screen/models/v_card_data.dart';
import 'package:magic_epaper_app/ndef_screen/widgets/v_card_form.dart';

class NFCVCardWriteCard extends StatefulWidget {
  final bool isWriting;
  final VCardData? vCardData;
  final Function(VCardData) onVCardChanged;
  final VoidCallback onWriteVCard;

  const NFCVCardWriteCard({
    super.key,
    required this.isWriting,
    this.vCardData,
    required this.onVCardChanged,
    required this.onWriteVCard,
  });

  @override
  State<NFCVCardWriteCard> createState() => _NFCVCardWriteCardState();
}

class _NFCVCardWriteCardState extends State<NFCVCardWriteCard> {
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
              'vCard Contact',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            VCardFormWidget(
              initialData: widget.vCardData,
              onVCardChanged: widget.onVCardChanged,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.isWriting ? null : widget.onWriteVCard,
                icon: widget.isWriting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.contact_page),
                label:
                    Text(widget.isWriting ? 'Writing vCard...' : 'Write vCard'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
