import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/util/image_picker_util.dart';
import 'package:magicepaperapp/card_templates/entry_pass_tag_card_widget.dart';
import 'package:magicepaperapp/card_templates/entry_pass_tag_model.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/pro_image_editor/features/movable_background_image.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/card_templates/util/responsive_layout_util.dart';
import 'package:magicepaperapp/card_templates/util/barcode_scanner_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class EntryPassTagForm extends StatefulWidget {
  final int width;
  final int height;

  const EntryPassTagForm(
      {super.key, required this.width, required this.height});

  @override
  State<EntryPassTagForm> createState() => _EntryPassTagFormState();
}

class _EntryPassTagFormState extends State<EntryPassTagForm> {
  final _formKey = GlobalKey<FormState>();
  final _venueNameController = TextEditingController();
  final _visitorNameController = TextEditingController();
  final _passTypeController = TextEditingController();
  final _validDateController = TextEditingController();
  final _passIdController = TextEditingController();
  final _qrDataController = TextEditingController();

  final Map<String, FocusNode> _fieldFocusNodes = {
    'venueName': FocusNode(),
    'visitorName': FocusNode(),
    'passType': FocusNode(),
    'passId': FocusNode(),
    'qr': FocusNode(),
  };

  File? _profileImage;
  bool _isGenerating = false;

  late EntryPassTagModel _passData;

  @override
  void initState() {
    super.initState();
    _passData = EntryPassTagModel(
      venueName: '',
      visitorName: '',
      passType: '',
      validDate: '',
      passId: '',
      qrData: '',
    );

    _venueNameController.addListener(_updatePreview);
    _visitorNameController.addListener(_updatePreview);
    _passTypeController.addListener(_updatePreview);
    _validDateController.addListener(_updatePreview);
    _passIdController.addListener(_updatePreview);
    _qrDataController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _venueNameController.removeListener(_updatePreview);
    _visitorNameController.removeListener(_updatePreview);
    _passTypeController.removeListener(_updatePreview);
    _validDateController.removeListener(_updatePreview);
    _passIdController.removeListener(_updatePreview);
    _qrDataController.removeListener(_updatePreview);

    _venueNameController.dispose();
    _visitorNameController.dispose();
    _passTypeController.dispose();
    _validDateController.dispose();
    _passIdController.dispose();
    _qrDataController.dispose();

    for (final node in _fieldFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      _passData = EntryPassTagModel(
        venueName: _venueNameController.text,
        visitorName: _visitorNameController.text,
        passType: _passTypeController.text,
        validDate: _validDateController.text,
        passId: _passIdController.text,
        qrData: _qrDataController.text,
        profileImage: _profileImage,
      );
    });
  }

  Future<void> _pickImage() async {
    final picked = await pickAndEditImage(context);
    if (picked != null && mounted) {
      _profileImage = picked;
      _updatePreview();
    }
  }

  Future<void> _scanQrData() async {
    final code = await scanCode(context);
    if (!mounted) return;
    if (code != null && code.isNotEmpty) {
      _qrDataController.text = code;
    }
  }

  void _handleEditRequest(String elementId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      if (elementId == 'profileImage') {
        _pickImage();
        return;
      }
      if (elementId == 'validDate') {
        _pickValidDate();
        return;
      }
      _fieldFocusNodes[elementId]?.requestFocus();
    });
  }

  Future<void> _pickValidDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (!mounted || picked == null) return;
    _validDateController.text = _formatDate(picked);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = date.day.toString().padLeft(2, '0');
    return '$day ${months[date.month - 1]} ${date.year}';
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isGenerating = true;
    });

    try {
      final List<LayerSpec> layers = [];

      final layoutParams = ResponsiveLayoutUtil.getEntryPassTagLayout(
          widget.width, widget.height);

      if (_profileImage != null) {
        layers.add(LayerSpec.widget(
          widget: ClipOval(
            child: Image.file(_profileImage!,
                width: 200, height: 200, fit: BoxFit.cover),
          ),
          offset: layoutParams.profileImageOffset,
          scale: layoutParams.profileImageScale,
          kind: LayerKind.image,
          elementId: 'profileImage',
        ));
      }

      if (_passData.venueName.isNotEmpty) {
        layers.add(LayerSpec.text(
          textStyle: TextStyle(
            fontSize: layoutParams.venueNameFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          text: _passData.venueName,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.center,
          offset: layoutParams.venueNameOffset,
          scale: layoutParams.venueNameScale,
          elementId: 'venueName',
        ));
      }

      if (_passData.visitorName.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.visitorNamePrefix}${_passData.visitorName}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['visitorName']!,
          scale: layoutParams.textFieldScale,
          elementId: 'visitorName',
        ));
      }

      if (_passData.passType.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.passTypePrefix}${_passData.passType}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['passType']!,
          scale: layoutParams.textFieldScale,
          elementId: 'passType',
        ));
      }

      if (_passData.validDate.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.validDatePrefix}${_passData.validDate}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['validDate']!,
          scale: layoutParams.textFieldScale,
          elementId: 'validDate',
        ));
      }

      if (_passData.passId.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.passIdPrefix}${_passData.passId}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['passId']!,
          scale: layoutParams.textFieldScale,
          elementId: 'passId',
        ));
      }

      if (_passData.qrData.isNotEmpty) {
        layers.add(LayerSpec.widget(
          widget: BarcodeWidget(
            padding: const EdgeInsets.all(Dimens.spacingXxs),
            backgroundColor: colorWhite,
            barcode: Barcode.qrCode(),
            data: _passData.qrData,
            width: layoutParams.qrCodeSize.width,
            height: layoutParams.qrCodeSize.height,
          ),
          offset: layoutParams.qrCodeOffset,
          scale: layoutParams.qrCodeScale,
          kind: LayerKind.barcode,
          elementId: 'qr',
        ));
      }

      final result = await Navigator.of(context).push<Object>(
        MaterialPageRoute(
          builder: (context) => MovableBackgroundImageExample(
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
      } else if (result is String) {
        _handleEditRequest(result);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: -1,
      showBackButton: true,
      titleWidget: Text(
        appLocalizations.entryPassTagTitle,
        style: const TextStyle(
          fontSize: Dimens.fontSizeXxl,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Dimens.spacingL, Dimens.spacingL,
              Dimens.spacingL, Dimens.spacingL),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.previewPass,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacingM),
              EntryPassTagCardWidget(data: _passData),
              const SizedBox(height: Dimens.spacingXl),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: Dimens.spacingXl),
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusXl),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
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
                            const Icon(Icons.edit_outlined,
                                color: colorAccent, size: Dimens.iconSizeM),
                            const SizedBox(width: Dimens.spacingS),
                            Text(
                              appLocalizations.entryPassDetails,
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
                          appLocalizations.fillDetailsToCreatePass,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: Dimens.spacingXl),
                        _buildPhotoSection(),
                        const SizedBox(height: Dimens.spacingXl),
                        _buildTextFormField(
                          controller: _venueNameController,
                          focusNode: _fieldFocusNodes['venueName'],
                          label: appLocalizations.venueName,
                          hint: appLocalizations.enterVenueName,
                          icon: Icons.location_on_outlined,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? appLocalizations.pleaseEnterVenueName
                                  : null,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _visitorNameController,
                          focusNode: _fieldFocusNodes['visitorName'],
                          label: appLocalizations.visitorName,
                          hint: appLocalizations.enterVisitorName,
                          icon: Icons.person_outline,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? appLocalizations.pleaseEnterVisitorName
                                  : null,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _passTypeController,
                          focusNode: _fieldFocusNodes['passType'],
                          label: appLocalizations.passType,
                          hint: appLocalizations.enterPassType,
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _validDateController,
                          label: appLocalizations.validDate,
                          hint: appLocalizations.enterValidDate,
                          icon: Icons.calendar_today_outlined,
                          readOnly: true,
                          onTap: _pickValidDate,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _passIdController,
                          focusNode: _fieldFocusNodes['passId'],
                          label: appLocalizations.passId,
                          hint: appLocalizations.enterPassId,
                          icon: Icons.confirmation_number_outlined,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _qrDataController,
                          focusNode: _fieldFocusNodes['qr'],
                          label: appLocalizations.qrCodeData,
                          hint: appLocalizations.enterQrCodeData,
                          icon: Icons.qr_code_outlined,
                          maxLines: 2,
                          maxLength: 250,
                          onScan: _scanQrData,
                        ),
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
                    backgroundColor:
                        colorPrimary.withAlpha(_isGenerating ? 125 : 255),
                    foregroundColor:
                        Colors.white.withAlpha(_isGenerating ? 178 : 255),
                    elevation: _isGenerating ? 0 : 2,
                    shadowColor: colorPrimary.withValues(alpha: 0.3),
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
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: Dimens.spacingM),
                            Text(
                              appLocalizations.generatingPass,
                              style: const TextStyle(
                                  fontSize: Dimens.fontSizeL,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.card_membership_outlined,
                                size: 18),
                            const SizedBox(width: Dimens.spacingS),
                            Text(
                              appLocalizations.generatePass,
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    VoidCallback? onScan,
    bool readOnly = false,
    VoidCallback? onTap,
    int? maxLength = 25,
    FocusNode? focusNode,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorPrimary,
          selectionColor: colorPrimary.withValues(alpha: 0.3),
          selectionHandleColor: colorPrimary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: colorPrimary,
          hoverColor: colorPrimary.withValues(alpha: 0.3),
        ),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        maxLines: maxLines,
        maxLength: maxLength,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(
          fontSize: Dimens.fontSizeL,
          color: colorBlack,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: colorPrimary,
        decoration: InputDecoration(
          counterText: '',
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: colorAccent, size: Dimens.iconSizeM),
          suffixIcon: onScan != null
              ? IconButton(
                  tooltip: appLocalizations.scanQrCode,
                  icon: const Icon(Icons.qr_code_scanner, color: colorAccent),
                  onPressed: onScan,
                )
              : null,
          labelStyle: TextStyle(
            color: colorBlack.withValues(alpha: 0.7),
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w400,
          ),
          floatingLabelStyle: const TextStyle(
            color: colorPrimary,
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: const BorderSide(color: colorPrimary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingL, vertical: 14),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Card(
      color: Colors.grey.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.photo_camera_outlined,
                    color: colorAccent, size: 18),
                const SizedBox(width: Dimens.spacingS),
                Text(
                  appLocalizations.profilePhoto,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeM,
                    fontWeight: FontWeight.w600,
                    color: colorBlack,
                  ),
                ),
                const Spacer(),
                if (_profileImage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.spacingS,
                        vertical: Dimens.spacingXs),
                    decoration: BoxDecoration(
                      color: colorPrimary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(Dimens.radiusXl),
                    ),
                    child: Text(
                      appLocalizations.selected,
                      style: TextStyle(
                        fontSize: Dimens.fontSizeS,
                        color: colorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Dimens.spacingM),
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(Dimens.radiusM),
              splashColor: colorAccent.withValues(alpha: 0.1),
              highlightColor: colorAccent.withValues(alpha: 0.05),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimens.spacingL),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.radiusM),
                  border: Border.all(
                    color: _profileImage != null
                        ? colorPrimary
                        : Colors.grey.shade300,
                    width: _profileImage != null ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _profileImage != null
                              ? colorPrimary.withValues(alpha: 0.3)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: _profileImage != null
                          ? Stack(
                              children: [
                                ClipOval(
                                  child: Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: colorPrimary,
                                      borderRadius:
                                          BorderRadius.circular(Dimens.radiusM),
                                    ),
                                    padding:
                                        const EdgeInsets.all(Dimens.spacingXxs),
                                    child: const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Icon(
                              Icons.add_photo_alternate,
                              size: 28,
                              color: Colors.grey.shade400,
                            ),
                    ),
                    const SizedBox(width: Dimens.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profileImage != null
                                ? appLocalizations.photoSelected
                                : appLocalizations.selectProfilePhoto,
                            style: TextStyle(
                              fontSize: Dimens.fontSizeM,
                              fontWeight: FontWeight.w600,
                              color: _profileImage != null
                                  ? colorPrimary
                                  : colorBlack,
                            ),
                          ),
                          const SizedBox(height: Dimens.spacingXs),
                          Text(
                            _profileImage != null
                                ? appLocalizations.tapToChangePhoto
                                : appLocalizations.tapToSelectFromGallery,
                            style: TextStyle(
                              fontSize: Dimens.fontSizeS,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(Dimens.spacingS),
                      decoration: BoxDecoration(
                        color: _profileImage != null
                            ? colorPrimary.withValues(alpha: 0.3)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(Dimens.radiusRound),
                      ),
                      child: Icon(
                        _profileImage != null
                            ? Icons.edit
                            : Icons.arrow_forward_ios,
                        color: _profileImage != null
                            ? colorPrimary
                            : Colors.grey.shade400,
                        size: _profileImage != null ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
