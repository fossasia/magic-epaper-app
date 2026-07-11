import 'package:flutter/material.dart';

import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/ndef_screen/models/v_card_data.dart';
import 'package:magicepaperapp/ndef_screen/widgets/v_card_form.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

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
  final VCardData? vCardData;
  final Function(VCardData) onVCardChanged;
  final VoidCallback onWriteVCard;

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
    this.vCardData,
    required this.onVCardChanged,
    required this.onWriteVCard,
  });

  @override
  State<NFCWriteCard> createState() => _NFCWriteCardState();
}

class _NFCWriteCardState extends State<NFCWriteCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorWhite,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.spacingS),
        child: Column(
          children: [
            _buildCard(
              child: Column(
                children: [
                  VCardFormWidget(
                    initialData: widget.vCardData,
                    onVCardChanged: widget.onVCardChanged,
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  _buildActionButton(
                    onPressed: widget.isWriting ? null : widget.onWriteVCard,
                    icon: widget.isWriting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(colorWhite),
                            ),
                          )
                        : const Icon(Icons.contact_page, color: colorWhite),
                    label:
                        widget.isWriting ? 'Writing vCard...' : 'Write vCard',
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimens.spacingL),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(appLocalizations.writeNdefRecords),
                  const SizedBox(height: Dimens.spacingXl),
                  _buildRecordSection(
                    title: appLocalizations.textRecord,
                    icon: Icons.text_fields,
                    child: Column(
                      children: [
                        _buildTextField(
                          onChanged: widget.onTextChanged,
                          hintText: appLocalizations.enterTextToWriteToNfcTag,
                          prefixIcon: Icons.text_format,
                          maxLines: 2,
                        ),
                        const SizedBox(height: Dimens.spacingM),
                        _buildActionButton(
                          onPressed: (widget.isWriting ||
                                  widget.textValue.trim().isEmpty)
                              ? null
                              : widget.onWriteText,
                          icon: widget.isWriting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        colorWhite),
                                  ),
                                )
                              : const Icon(Icons.edit, color: colorWhite),
                          label: widget.isWriting
                              ? appLocalizations.writing
                              : appLocalizations.writeText,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.spacingXl),
                  _buildRecordSection(
                    title: appLocalizations.urlRecord,
                    icon: Icons.link,
                    child: Column(
                      children: [
                        _buildTextField(
                          onChanged: widget.onUrlChanged,
                          hintText: appLocalizations.enterUrl,
                          prefixIcon: Icons.link,
                        ),
                        const SizedBox(height: Dimens.spacingM),
                        _buildActionButton(
                          onPressed: (widget.isWriting ||
                                  widget.urlValue.trim().isEmpty)
                              ? null
                              : widget.onWriteUrl,
                          icon: widget.isWriting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        colorWhite),
                                  ),
                                )
                              : const Icon(Icons.link, color: colorWhite),
                          label: widget.isWriting
                              ? appLocalizations.writing
                              : appLocalizations.writeUrl,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.spacingXl),
                  _buildRecordSection(
                    title: appLocalizations.wifiRecord,
                    icon: Icons.wifi,
                    child: Column(
                      children: [
                        _buildTextField(
                          onChanged: widget.onWifiSSIDChanged,
                          hintText: appLocalizations.wifiNetworkNameSsid,
                          prefixIcon: Icons.wifi,
                        ),
                        const SizedBox(height: Dimens.spacingM),
                        _buildTextField(
                          onChanged: widget.onWifiPasswordChanged,
                          hintText: appLocalizations.wifiPassword,
                          prefixIcon: Icons.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: Dimens.spacingM),
                        _buildActionButton(
                          onPressed: (widget.isWriting ||
                                  widget.wifiSSIDValue.trim().isEmpty)
                              ? null
                              : widget.onWriteWifi,
                          icon: widget.isWriting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        colorWhite),
                                  ),
                                )
                              : const Icon(Icons.wifi, color: colorWhite),
                          label: widget.isWriting
                              ? appLocalizations.writing
                              : appLocalizations.writeWifi,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.spacingXl),
                  _buildRecordSection(
                    title: appLocalizations.writeAllRecords,
                    icon: Icons.layers,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizations.writeAllNonEmptyFieldsDescription,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: Dimens.spacingM),
                        _buildActionButton(
                          onPressed:
                              widget.isWriting ? null : widget.onWriteMultiple,
                          icon: widget.isWriting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        colorWhite),
                                  ),
                                )
                              : const Icon(Icons.layers, color: colorWhite),
                          label: widget.isWriting
                              ? appLocalizations.writing
                              : appLocalizations.writeMultipleRecords,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimens.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingL),
        child: child,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: Dimens.fontSizeXl,
        fontWeight: FontWeight.bold,
        color: colorBlack,
      ),
    );
  }

  Widget _buildRecordSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(color: mdGrey400.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: Dimens.iconSizeM, color: colorAccent),
              const SizedBox(width: Dimens.spacingS),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Dimens.fontSizeL,
                  color: colorBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacingM),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required Function(String) onChanged,
    required String hintText,
    required IconData prefixIcon,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return TextField(
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: 1,
      obscureText: obscureText,
      style: const TextStyle(fontSize: Dimens.fontSizeM),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            TextStyle(color: Colors.grey[500], fontSize: Dimens.fontSizeM),
        prefixIcon:
            Icon(prefixIcon, color: colorAccent, size: Dimens.iconSizeM),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          borderSide: const BorderSide(color: mdGrey400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          borderSide: BorderSide(color: mdGrey400.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          borderSide: const BorderSide(color: colorAccent, width: 2),
        ),
        filled: true,
        fillColor: colorWhite,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingL, vertical: Dimens.spacingM),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          style: const TextStyle(
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
        ),
      ),
    );
  }
}
