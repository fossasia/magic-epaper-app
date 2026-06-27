import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/util/image_picker_util.dart';
import 'package:magicepaperapp/card_templates/event_badge_card_widget.dart';
import 'package:magicepaperapp/card_templates/event_badge_model.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/pro_image_editor/features/movable_background_image.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/card_templates/util/responsive_layout_util.dart';
import 'package:magicepaperapp/card_templates/util/barcode_scanner_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class EventBadgeForm extends StatefulWidget {
  final int width;
  final int height;

  const EventBadgeForm({super.key, required this.width, required this.height});

  @override
  State<EventBadgeForm> createState() => _EventBadgeFormState();
}

class _EventBadgeFormState extends State<EventBadgeForm> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _attendeeNameController = TextEditingController();
  final _roleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _ticketIdController = TextEditingController();
  final _qrDataController = TextEditingController();

  final Map<String, FocusNode> _fieldFocusNodes = {
    'eventName': FocusNode(),
    'attendeeName': FocusNode(),
    'role': FocusNode(),
    'organization': FocusNode(),
    'ticketId': FocusNode(),
    'qr': FocusNode(),
  };

  File? _profileImage;
  bool _isGenerating = false;

  late EventBadgeModel _badgeData;

  @override
  void initState() {
    super.initState();
    _badgeData = EventBadgeModel(
      eventName: '',
      attendeeName: '',
      role: '',
      organization: '',
      ticketId: '',
      qrData: '',
    );

    _eventNameController.addListener(_updatePreview);
    _attendeeNameController.addListener(_updatePreview);
    _roleController.addListener(_updatePreview);
    _organizationController.addListener(_updatePreview);
    _ticketIdController.addListener(_updatePreview);
    _qrDataController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _eventNameController.removeListener(_updatePreview);
    _attendeeNameController.removeListener(_updatePreview);
    _roleController.removeListener(_updatePreview);
    _organizationController.removeListener(_updatePreview);
    _ticketIdController.removeListener(_updatePreview);
    _qrDataController.removeListener(_updatePreview);

    _eventNameController.dispose();
    _attendeeNameController.dispose();
    _roleController.dispose();
    _organizationController.dispose();
    _ticketIdController.dispose();
    _qrDataController.dispose();

    for (final node in _fieldFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      _badgeData = EventBadgeModel(
        eventName: _eventNameController.text,
        attendeeName: _attendeeNameController.text,
        role: _roleController.text,
        organization: _organizationController.text,
        ticketId: _ticketIdController.text,
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

  void _handleEditRequest(String elementId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      if (elementId == 'profileImage') {
        _pickImage();
        return;
      }
      _fieldFocusNodes[elementId]?.requestFocus();
    });
  }

  Future<void> _scanQrData() async {
    final code = await scanCode(context);
    if (!mounted) return;
    if (code != null && code.isNotEmpty) {
      _qrDataController.text = code;
    }
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

      final layoutParams =
          ResponsiveLayoutUtil.getEventBadgeLayout(widget.width, widget.height);

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

      if (_badgeData.eventName.isNotEmpty) {
        layers.add(LayerSpec.text(
          textStyle: TextStyle(
            fontSize: layoutParams.eventNameFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          text: _badgeData.eventName,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.center,
          offset: layoutParams.eventNameOffset,
          scale: layoutParams.eventNameScale,
          elementId: 'eventName',
        ));
      }

      if (_badgeData.attendeeName.isNotEmpty) {
        layers.add(LayerSpec.text(
          text:
              '${appLocalizations.attendeeNamePrefix}${_badgeData.attendeeName}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['attendeeName']!,
          scale: layoutParams.textFieldScale,
          elementId: 'attendeeName',
        ));
      }

      if (_badgeData.role.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.rolePrefix}${_badgeData.role}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['role']!,
          scale: layoutParams.textFieldScale,
          elementId: 'role',
        ));
      }

      if (_badgeData.organization.isNotEmpty) {
        layers.add(LayerSpec.text(
          text:
              '${appLocalizations.organizationPrefix}${_badgeData.organization}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['organization']!,
          scale: layoutParams.textFieldScale,
          elementId: 'organization',
        ));
      }

      if (_badgeData.ticketId.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.ticketIdPrefix}${_badgeData.ticketId}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['ticketId']!,
          scale: layoutParams.textFieldScale,
          elementId: 'ticketId',
        ));
      }

      if (_badgeData.qrData.isNotEmpty) {
        layers.add(LayerSpec.widget(
          widget: BarcodeWidget(
            padding: const EdgeInsets.all(2),
            backgroundColor: colorWhite,
            barcode: Barcode.qrCode(),
            data: _badgeData.qrData,
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
        appLocalizations.eventBadgeTitle,
        style: const TextStyle(
          fontSize: 20,
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
          padding: const EdgeInsets.fromLTRB(16.0, 16, 16.0, 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.previewBadge,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              EventBadgeCardWidget(data: _badgeData),
              const SizedBox(height: 20),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 20),
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.edit_outlined,
                                color: colorAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              appLocalizations.eventBadgeDetails,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          appLocalizations.fillDetailsToCreateBadge,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 20),
                        _buildPhotoSection(),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          controller: _eventNameController,
                          focusNode: _fieldFocusNodes['eventName'],
                          label: appLocalizations.eventName,
                          hint: appLocalizations.enterEventName,
                          icon: Icons.event_outlined,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? appLocalizations.pleaseEnterEventName
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _attendeeNameController,
                          focusNode: _fieldFocusNodes['attendeeName'],
                          label: appLocalizations.attendeeName,
                          hint: appLocalizations.enterAttendeeName,
                          icon: Icons.person_outline,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? appLocalizations.pleaseEnterAttendeeName
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _roleController,
                          focusNode: _fieldFocusNodes['role'],
                          label: appLocalizations.role,
                          hint: appLocalizations.enterRole,
                          icon: Icons.work_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _organizationController,
                          focusNode: _fieldFocusNodes['organization'],
                          label: appLocalizations.organization,
                          hint: appLocalizations.enterOrganization,
                          icon: Icons.business_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _ticketIdController,
                          focusNode: _fieldFocusNodes['ticketId'],
                          label: appLocalizations.ticketId,
                          hint: appLocalizations.enterTicketId,
                          icon: Icons.confirmation_number_outlined,
                        ),
                        const SizedBox(height: 16),
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
              const SizedBox(height: 24),
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
                      borderRadius: BorderRadius.circular(8.0),
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
                            const SizedBox(width: 12),
                            Text(
                              appLocalizations.generatingBadge,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.badge_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              appLocalizations.generateBadge,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
        style: const TextStyle(
          fontSize: 16,
          color: colorBlack,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: colorPrimary,
        decoration: InputDecoration(
          counterText: '',
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: colorAccent, size: 20),
          suffixIcon: onScan != null
              ? IconButton(
                  tooltip: appLocalizations.scanQrCode,
                  icon: const Icon(Icons.qr_code_scanner, color: colorAccent),
                  onPressed: onScan,
                )
              : null,
          labelStyle: TextStyle(
            color: colorBlack.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          floatingLabelStyle: const TextStyle(
            color: colorPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: colorPrimary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.photo_camera_outlined,
                    color: colorAccent, size: 18),
                const SizedBox(width: 8),
                Text(
                  appLocalizations.profilePhoto,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorBlack,
                  ),
                ),
                const Spacer(),
                if (_profileImage != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorPrimary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      appLocalizations.selected,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(8),
              splashColor: colorAccent.withValues(alpha: 0.1),
              highlightColor: colorAccent.withValues(alpha: 0.05),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(2),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profileImage != null
                                ? appLocalizations.photoSelected
                                : appLocalizations.selectProfilePhoto,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _profileImage != null
                                  ? colorPrimary
                                  : colorBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _profileImage != null
                                ? appLocalizations.tapToChangePhoto
                                : appLocalizations.tapToSelectFromGallery,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _profileImage != null
                            ? colorPrimary.withValues(alpha: 0.3)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
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
