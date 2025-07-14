import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';

class NFCWriteCard extends StatefulWidget {
  final bool isWriting;
  final VoidCallback onWriteText;
  final VoidCallback onWriteUrl;
  final VoidCallback onWriteWifi;
  final VoidCallback onWriteMultiple;
  final Function(String) onTextChanged;
  final Function(String) onUrlChanged;
  final Function(String) onWifiSSIDChanged;
  final Function(String) onWifiPasswordChanged;
  final String textValue;
  final String urlValue;
  final String wifiSSIDValue;
  final String wifiPasswordValue;

  const NFCWriteCard({
    super.key,
    required this.isWriting,
    required this.onWriteText,
    required this.onWriteUrl,
    required this.onWriteWifi,
    required this.onWriteMultiple,
    required this.onTextChanged,
    required this.onUrlChanged,
    required this.onWifiSSIDChanged,
    required this.onWifiPasswordChanged,
    required this.textValue,
    required this.urlValue,
    required this.wifiSSIDValue,
    required this.wifiPasswordValue,
  });

  @override
  State<NFCWriteCard> createState() => _NFCWriteCardState();
}

class _NFCWriteCardState extends State<NFCWriteCard> {
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
              StringConstants.writeNdefRecords,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(StringConstants.textRecord, Icons.text_fields),
            TextField(
              onChanged: widget.onTextChanged,
              decoration: const InputDecoration(
                hintText: StringConstants.enterTextToWriteToNfcTag,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.text_format),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (widget.isWriting || widget.textValue.trim().isEmpty)
                    ? null
                    : widget.onWriteText,
                icon: widget.isWriting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.edit),
                label: Text(widget.isWriting
                    ? StringConstants.writing
                    : StringConstants.writeText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            _buildSectionHeader(StringConstants.urlRecord, Icons.link),
            TextField(
              onChanged: widget.onUrlChanged,
              decoration: const InputDecoration(
                hintText: StringConstants.enterUrl,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (widget.isWriting || widget.urlValue.trim().isEmpty)
                    ? null
                    : widget.onWriteUrl,
                icon: widget.isWriting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.link),
                label: Text(widget.isWriting
                    ? StringConstants.writing
                    : StringConstants.writeUrl),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            _buildSectionHeader(StringConstants.wifiRecord, Icons.wifi),
            TextField(
              onChanged: widget.onWifiSSIDChanged,
              decoration: const InputDecoration(
                hintText: StringConstants.wifiNetworkNameSsid,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wifi),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: widget.onWifiPasswordChanged,
              decoration: const InputDecoration(
                hintText: StringConstants.wifiPassword,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    (widget.isWriting || widget.wifiSSIDValue.trim().isEmpty)
                        ? null
                        : widget.onWriteWifi,
                icon: widget.isWriting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.wifi),
                label: Text(widget.isWriting
                    ? StringConstants.writing
                    : StringConstants.writeWifi),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            _buildSectionHeader(StringConstants.writeAllRecords, Icons.layers),
            Text(
              StringConstants.writeAllNonEmptyFieldsDescription,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.isWriting ? null : widget.onWriteMultiple,
                icon: widget.isWriting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.layers),
                label: Text(widget.isWriting
                    ? StringConstants.writing
                    : StringConstants.writeMultipleRecords),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
