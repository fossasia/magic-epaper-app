import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/qr_tag_badge.dart';
import 'package:magicepaperapp/card_templates/qr_tag_card_widget.dart';
import 'package:magicepaperapp/card_templates/qr_tag_model.dart';
import 'package:magicepaperapp/card_templates/util/barcode_scanner_util.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/page_route_util.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class QrTagForm extends StatefulWidget {
  final int width;
  final int height;

  const QrTagForm({super.key, required this.width, required this.height});

  @override
  State<QrTagForm> createState() => _QrTagFormState();
}

class _QrTagFormState extends State<QrTagForm> {
  final _formKey = GlobalKey<FormState>();

  final _contentController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailSubjectController = TextEditingController();
  final _smsNumberController = TextEditingController();
  final _smsMessageController = TextEditingController();
  final _ssidController = TextEditingController();
  final _wifiPasswordController = TextEditingController();
  final _captionController = TextEditingController();

  QrTagType _type = QrTagType.link;
  String _wifiSecurity = 'WPA';
  bool _wifiHidden = false;
  bool _wifiPasswordVisible = false;
  String _selectedIconKey = defaultIconForType(QrTagType.link);
  bool _iconTouched = false;
  bool _isGenerating = false;

  late QrTagModel _data;

  @override
  void initState() {
    super.initState();
    _data = _buildModel();
    for (final c in _controllers) {
      c.addListener(_updatePreview);
    }
  }

  List<TextEditingController> get _controllers => [
        _contentController,
        _emailController,
        _emailSubjectController,
        _smsNumberController,
        _smsMessageController,
        _ssidController,
        _wifiPasswordController,
        _captionController,
      ];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.removeListener(_updatePreview);
      c.dispose();
    }
    super.dispose();
  }

  QrTagModel _buildModel() {
    return QrTagModel(
      type: _type,
      caption: _captionController.text,
      iconKey: _selectedIconKey,
      content: _contentController.text,
      emailAddress: _emailController.text,
      emailSubject: _emailSubjectController.text,
      smsNumber: _smsNumberController.text,
      smsMessage: _smsMessageController.text,
      ssid: _ssidController.text,
      wifiPassword: _wifiPasswordController.text,
      wifiSecurity: _wifiSecurity,
      wifiHidden: _wifiHidden,
    );
  }

  void _updatePreview() {
    setState(() => _data = _buildModel());
  }

  void _selectType(QrTagType type) {
    setState(() {
      _type = type;
      if (!_iconTouched) _selectedIconKey = defaultIconForType(type);
      _data = _buildModel();
    });
  }

  Future<void> _scanContent(TextEditingController controller) async {
    final code = await scanCode(context);
    if (!mounted) return;
    if (code != null && code.isNotEmpty) {
      controller.text = code;
    }
  }

  void _submitForm() async {
    FocusScope.of(context).unfocus();
    if (!_data.hasContent) {
      final msg = _type == QrTagType.wifi
          ? appLocalizations.qrWifiSsidRequired
          : appLocalizations.qrContentRequired;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final layers = <LayerSpec>[
        LayerSpec.widget(
          widget: SizedBox(
            width: widget.width.toDouble(),
            height: widget.height.toDouble(),
            child: QrTagBadge(data: _data),
          ),
          kind: LayerKind.generic,
          elementId: 'qrTag',
        ),
      ];

      final result = await Navigator.of(context).push<Object>(
        buildOpaqueSlideRoute(
          NativeCanvasEditor(
            width: widget.width,
            height: widget.height,
            initialLayers: layers,
          ),
        ),
      );

      if (!mounted) return;
      if (result is Uint8List) {
        Navigator.of(context)
          ..pop()
          ..pop(result);
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: -1,
      showBackButton: true,
      titleWidget: Text(
        appLocalizations.qrTagGenerator,
        style: const TextStyle(
          fontSize: Dimens.fontSizeXxl,
          fontWeight: FontWeight.bold,
          color: colorWhite,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimens.spacingL),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.previewQrTag,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacingM),
              QrTagCardWidget(
                data: _data,
                width: widget.width,
                height: widget.height,
              ),
              const SizedBox(height: Dimens.spacingXl),
              const Divider(height: 1, color: grey500),
              const SizedBox(height: Dimens.spacingXl),
              Card(
                color: colorWhite,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusXl),
                  side: BorderSide(color: grey300, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.spacingXl),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.qr_code_2,
                                color: colorAccent, size: Dimens.iconSizeM),
                            const SizedBox(width: Dimens.spacingS),
                            Text(
                              appLocalizations.qrTagDetails,
                              style: const TextStyle(
                                fontSize: Dimens.fontSizeXl,
                                fontWeight: FontWeight.bold,
                                color: colorBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimens.spacingSm),
                        Text(
                          appLocalizations.qrTagDetailsSubtitle,
                          style: TextStyle(fontSize: 13, color: grey600),
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTypeSelector(),
                        const SizedBox(height: Dimens.spacingL),
                        ..._buildTypeFields(),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _captionController,
                          label: appLocalizations.qrCaptionLabel,
                          hint: appLocalizations.qrCaptionHint,
                          icon: Icons.short_text,
                          maxLength: 40,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildIconDropdown(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacingXxl),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isGenerating ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary.withValues(
                        alpha: _isGenerating ? 0.49 : 1.0),
                    foregroundColor:
                        colorWhite.withValues(alpha: _isGenerating ? 0.7 : 1.0),
                    elevation: _isGenerating ? 0 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.radiusM),
                    ),
                  ),
                  child: _isGenerating
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(colorWhite),
                              ),
                            ),
                            const SizedBox(width: Dimens.spacingM),
                            Text(
                              appLocalizations.generatingQrTag,
                              style: const TextStyle(
                                  fontSize: Dimens.fontSizeL,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code_2, size: 18),
                            const SizedBox(width: Dimens.spacingS),
                            Text(
                              appLocalizations.generateQrTag,
                              style: const TextStyle(
                                  fontSize: Dimens.fontSizeL,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(QrTagType type) {
    switch (type) {
      case QrTagType.link:
        return appLocalizations.qrTypeLink;
      case QrTagType.wifi:
        return appLocalizations.qrTypeWifi;
      case QrTagType.phone:
        return appLocalizations.qrTypePhone;
      case QrTagType.email:
        return appLocalizations.qrTypeEmail;
      case QrTagType.sms:
        return appLocalizations.qrTypeSms;
      case QrTagType.text:
        return appLocalizations.qrTypeText;
    }
  }

  IconData _typeIcon(QrTagType type) {
    switch (type) {
      case QrTagType.link:
        return Icons.link;
      case QrTagType.wifi:
        return Icons.wifi;
      case QrTagType.phone:
        return Icons.phone;
      case QrTagType.email:
        return Icons.email_outlined;
      case QrTagType.sms:
        return Icons.sms_outlined;
      case QrTagType.text:
        return Icons.notes;
    }
  }

  String _typeHint(QrTagType type) {
    switch (type) {
      case QrTagType.link:
        return appLocalizations.qrHintLink;
      case QrTagType.wifi:
        return appLocalizations.qrHintWifi;
      case QrTagType.phone:
        return appLocalizations.qrHintPhone;
      case QrTagType.email:
        return appLocalizations.qrHintEmail;
      case QrTagType.sms:
        return appLocalizations.qrHintSms;
      case QrTagType.text:
        return appLocalizations.qrHintText;
    }
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.qrTypeLabel,
          style: TextStyle(
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w600,
            color: colorBlack.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: Dimens.spacingM),
        Wrap(
          spacing: Dimens.spacingS,
          runSpacing: Dimens.spacingS,
          children: [
            for (final type in QrTagType.values)
              ChoiceChip(
                avatar: Icon(
                  _typeIcon(type),
                  size: 18,
                  color: _type == type ? colorWhite : colorAccent,
                ),
                label: Text(_typeLabel(type)),
                selected: _type == type,
                showCheckmark: false,
                onSelected: _isGenerating ? null : (_) => _selectType(type),
                selectedColor: colorPrimary,
                labelStyle: TextStyle(
                  color: _type == type ? colorWhite : colorBlack,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: grey50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusL),
                  side:
                      BorderSide(color: _type == type ? colorPrimary : grey300),
                ),
              ),
          ],
        ),
        const SizedBox(height: Dimens.spacingM),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingM, vertical: Dimens.spacingS),
          decoration: BoxDecoration(
            color: colorAccent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline, size: 16, color: colorAccent),
              const SizedBox(width: Dimens.spacingS),
              Expanded(
                child: Text(
                  _typeHint(_type),
                  style: TextStyle(fontSize: 12.5, color: grey600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTypeFields() {
    switch (_type) {
      case QrTagType.link:
        return [
          _buildTextFormField(
            controller: _contentController,
            label: appLocalizations.qrLinkLabel,
            hint: appLocalizations.qrLinkHint,
            icon: Icons.link,
            keyboardType: TextInputType.url,
            maxLength: 300,
            onScan: () => _scanContent(_contentController),
          ),
        ];
      case QrTagType.text:
        return [
          _buildTextFormField(
            controller: _contentController,
            label: appLocalizations.qrTextLabel,
            hint: appLocalizations.qrTextHint,
            icon: Icons.notes,
            maxLines: 3,
            maxLength: 300,
          ),
        ];
      case QrTagType.phone:
        return [
          _buildTextFormField(
            controller: _contentController,
            label: appLocalizations.qrPhoneLabel,
            hint: appLocalizations.qrPhoneHint,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            maxLength: 30,
          ),
        ];
      case QrTagType.email:
        return [
          _buildTextFormField(
            controller: _emailController,
            label: appLocalizations.qrEmailLabel,
            hint: appLocalizations.qrEmailHint,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            maxLength: 100,
          ),
          const SizedBox(height: Dimens.spacingL),
          _buildTextFormField(
            controller: _emailSubjectController,
            label: appLocalizations.qrEmailSubjectLabel,
            hint: appLocalizations.qrEmailSubjectLabel,
            icon: Icons.subject,
            maxLength: 100,
          ),
        ];
      case QrTagType.sms:
        return [
          _buildTextFormField(
            controller: _smsNumberController,
            label: appLocalizations.qrSmsNumberLabel,
            hint: appLocalizations.qrPhoneHint,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            maxLength: 30,
          ),
          const SizedBox(height: Dimens.spacingL),
          _buildTextFormField(
            controller: _smsMessageController,
            label: appLocalizations.qrSmsMessageLabel,
            hint: appLocalizations.qrSmsMessageLabel,
            icon: Icons.sms_outlined,
            maxLines: 2,
            maxLength: 160,
          ),
        ];
      case QrTagType.wifi:
        return [
          _buildTextFormField(
            controller: _ssidController,
            label: appLocalizations.qrWifiSsidLabel,
            hint: appLocalizations.qrWifiSsidLabel,
            icon: Icons.wifi,
            maxLength: 60,
          ),
          const SizedBox(height: Dimens.spacingL),
          _buildTextFormField(
            controller: _wifiPasswordController,
            label: appLocalizations.qrWifiPasswordLabel,
            hint: appLocalizations.qrWifiPasswordLabel,
            icon: Icons.vpn_key_outlined,
            maxLength: 63,
            enabled: _wifiSecurity != 'nopass',
            obscureText: !_wifiPasswordVisible,
            onToggleObscure: () =>
                setState(() => _wifiPasswordVisible = !_wifiPasswordVisible),
          ),
          const SizedBox(height: Dimens.spacingL),
          _buildWifiSecurityDropdown(),
          const SizedBox(height: Dimens.spacingS),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: colorPrimary,
            title: Text(
              appLocalizations.qrWifiHiddenLabel,
              style: const TextStyle(
                  fontSize: Dimens.fontSizeM, color: colorBlack),
            ),
            value: _wifiHidden,
            onChanged: _isGenerating
                ? null
                : (v) => setState(() {
                      _wifiHidden = v;
                      _data = _buildModel();
                    }),
          ),
        ];
    }
  }

  Widget _buildWifiSecurityDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _wifiSecurity,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: colorAccent),
      decoration: _fieldDecoration(
        appLocalizations.qrWifiSecurityLabel,
        Icons.security_outlined,
      ),
      items: [
        DropdownMenuItem(
            value: 'WPA', child: Text(appLocalizations.qrWifiSecurityWpa)),
        DropdownMenuItem(
            value: 'WEP', child: Text(appLocalizations.qrWifiSecurityWep)),
        DropdownMenuItem(
            value: 'nopass', child: Text(appLocalizations.qrWifiSecurityNone)),
      ],
      onChanged: _isGenerating
          ? null
          : (value) {
              if (value == null) return;
              setState(() {
                _wifiSecurity = value;
                _data = _buildModel();
              });
            },
    );
  }

  String _iconLabel(String key) {
    switch (key) {
      case 'wifi':
        return 'Wi-Fi';
      case 'sms':
        return 'SMS';
      default:
        return key[0].toUpperCase() + key.substring(1);
    }
  }

  Widget _buildIconDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedIconKey,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: colorAccent),
      decoration: _fieldDecoration(
        appLocalizations.qrTagIconLabel,
        Icons.emoji_symbols_outlined,
      ),
      items: [
        for (final option in qrTagIconOptions)
          DropdownMenuItem<String>(
            value: option.key,
            child: Row(
              children: [
                Icon(
                  option.icon ?? Icons.not_interested,
                  color: option.icon == null ? grey400 : colorBlack,
                  size: Dimens.iconSizeM,
                ),
                const SizedBox(width: Dimens.spacingM),
                Text(
                  option.key == 'none'
                      ? appLocalizations.qrTagIconNone
                      : _iconLabel(option.key),
                  style: const TextStyle(
                      fontSize: Dimens.fontSizeM, color: colorBlack),
                ),
              ],
            ),
          ),
      ],
      onChanged: _isGenerating
          ? null
          : (value) {
              if (value == null) return;
              setState(() {
                _selectedIconKey = value;
                _iconTouched = true;
                _data = _buildModel();
              });
            },
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: colorAccent, size: Dimens.iconSizeM),
      labelStyle: TextStyle(
        color: colorBlack.withValues(alpha: 0.7),
        fontSize: Dimens.fontSizeM,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: const TextStyle(
        color: colorPrimary,
        fontSize: Dimens.fontSizeM,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        borderSide: BorderSide(color: grey300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        borderSide: BorderSide(color: grey300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        borderSide: const BorderSide(color: colorPrimary, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: Dimens.spacingL, vertical: 14),
      filled: true,
      fillColor: grey50,
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    VoidCallback? onScan,
    int? maxLength,
    bool enabled = true,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
  }) {
    Widget? suffix;
    if (onToggleObscure != null) {
      suffix = IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: colorAccent,
        ),
        onPressed: onToggleObscure,
      );
    } else if (onScan != null) {
      suffix = IconButton(
        tooltip: appLocalizations.scanBarcodeTooltip,
        icon: const Icon(Icons.qr_code_scanner, color: colorAccent),
        onPressed: onScan,
      );
    }
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorPrimary,
          selectionColor: colorPrimary.withValues(alpha: 0.2),
          selectionHandleColor: colorPrimary,
        ),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: Dimens.fontSizeL,
          color: colorBlack,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: colorPrimary,
        decoration: _fieldDecoration(label, icon).copyWith(
          counterText: '',
          hintText: hint,
          hintStyle: TextStyle(
            color: grey500,
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
