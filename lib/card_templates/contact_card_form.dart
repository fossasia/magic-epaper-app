import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/util/image_picker_util.dart';
import 'package:magicepaperapp/card_templates/card_template_result.dart';
import 'package:magicepaperapp/card_templates/contact_card_badge.dart';
import 'package:magicepaperapp/card_templates/contact_card_card_widget.dart';
import 'package:magicepaperapp/card_templates/contact_card_model.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:magicepaperapp/util/page_route_util.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/card_templates/util/barcode_scanner_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class ContactCardForm extends StatefulWidget {
  final int width;
  final int height;
  final ContactCardModel? initialModel;
  final String? existingImageId;

  const ContactCardForm({
    super.key,
    required this.width,
    required this.height,
    this.initialModel,
    this.existingImageId,
  });

  @override
  State<ContactCardForm> createState() => _ContactCardFormState();
}

class _ContactCardFormState extends State<ContactCardForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _linkController = TextEditingController();

  final Map<String, FocusNode> _fieldFocusNodes = {
    'fullName': FocusNode(),
    'jobTitle': FocusNode(),
    'company': FocusNode(),
    'phone': FocusNode(),
    'email': FocusNode(),
    'link': FocusNode(),
  };

  File? _profileImage;
  bool _isGenerating = false;
  ContactQrMode _qrMode = ContactQrMode.vCard;

  late ContactCardModel _contactData;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialModel;
    if (initial != null) {
      _fullNameController.text = initial.fullName;
      _jobTitleController.text = initial.jobTitle;
      _companyController.text = initial.company;
      _phoneController.text = initial.phone;
      _emailController.text = initial.email;
      _linkController.text = initial.link;
      _qrMode = initial.qrMode;
      _profileImage = initial.profileImage;
    }
    _contactData = _buildModel();

    _fullNameController.addListener(_updatePreview);
    _jobTitleController.addListener(_updatePreview);
    _companyController.addListener(_updatePreview);
    _phoneController.addListener(_updatePreview);
    _emailController.addListener(_updatePreview);
    _linkController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_updatePreview);
    _jobTitleController.removeListener(_updatePreview);
    _companyController.removeListener(_updatePreview);
    _phoneController.removeListener(_updatePreview);
    _emailController.removeListener(_updatePreview);
    _linkController.removeListener(_updatePreview);

    _fullNameController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _linkController.dispose();

    for (final node in _fieldFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  ContactCardModel _buildModel() {
    return ContactCardModel(
      fullName: _fullNameController.text,
      jobTitle: _jobTitleController.text,
      company: _companyController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      link: _linkController.text,
      qrMode: _qrMode,
      profileImage: _profileImage,
    );
  }

  void _updatePreview() {
    setState(() {
      _contactData = _buildModel();
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

  Future<void> _scanLink() async {
    final code = await scanCode(context);
    if (!mounted) return;
    if (code != null && code.isNotEmpty) {
      _linkController.text = code;
    }
  }

  void _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_contactData.hasAnyData) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.contactFillAtLeastOneField)),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final layers = <LayerSpec>[
        LayerSpec.widget(
          widget: SizedBox(
            width: widget.width.toDouble(),
            height: widget.height.toDouble(),
            child: ContactCardBadge(data: _contactData, interactive: true),
          ),
          kind: LayerKind.generic,
          elementId: 'contactCard',
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
        final templateResult = CardTemplateResult(
          result,
          metadata: {'contactCard': _contactData.toJson()},
        );
        if (widget.existingImageId != null) {
          Navigator.of(context).pop(templateResult);
        } else {
          Navigator.of(context)
            ..pop()
            ..pop(templateResult);
        }
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
        appLocalizations.contactTagTitle,
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
          padding: const EdgeInsets.fromLTRB(Dimens.spacingL, Dimens.spacingL,
              Dimens.spacingL, Dimens.spacingL),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.previewContactCard,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacingM),
              ContactCardWidget(
                data: _contactData,
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
                            const Icon(Icons.contact_page_outlined,
                                color: colorAccent, size: Dimens.iconSizeM),
                            const SizedBox(width: Dimens.spacingS),
                            Text(
                              appLocalizations.contactCardDetails,
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
                          appLocalizations.fillDetailsToCreateContact,
                          style: TextStyle(fontSize: 13, color: grey600),
                        ),
                        const SizedBox(height: Dimens.spacingXl),
                        _buildPhotoSection(),
                        const SizedBox(height: Dimens.spacingXl),
                        _buildTextFormField(
                          controller: _fullNameController,
                          focusNode: _fieldFocusNodes['fullName'],
                          label: appLocalizations.fullName,
                          hint: appLocalizations.enterFullName,
                          icon: Icons.person_outline,
                          maxLength: 40,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _jobTitleController,
                          focusNode: _fieldFocusNodes['jobTitle'],
                          label: appLocalizations.jobTitle,
                          hint: appLocalizations.enterJobTitle,
                          icon: Icons.work_outline,
                          maxLength: 40,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _companyController,
                          focusNode: _fieldFocusNodes['company'],
                          label: appLocalizations.companyOrganization,
                          hint: appLocalizations.enterCompanyOrganization,
                          icon: Icons.business_outlined,
                          maxLength: 40,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _phoneController,
                          focusNode: _fieldFocusNodes['phone'],
                          label: appLocalizations.phoneNumber,
                          hint: appLocalizations.enterPhoneNumber,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          maxLength: 30,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _emailController,
                          focusNode: _fieldFocusNodes['email'],
                          label: appLocalizations.emailAddress,
                          hint: appLocalizations.enterEmailAddress,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 50,
                        ),
                        const SizedBox(height: Dimens.spacingXl),
                        _buildQrModeSection(),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _linkController,
                          focusNode: _fieldFocusNodes['link'],
                          label: _qrMode == ContactQrMode.link
                              ? appLocalizations.contactLinkLabel
                              : appLocalizations.contactWebsiteLabel,
                          hint: appLocalizations.contactLinkHint,
                          icon: Icons.link_outlined,
                          keyboardType: TextInputType.url,
                          maxLength: 250,
                          onScan: _scanLink,
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
                        colorWhite.withAlpha(_isGenerating ? 178 : 255),
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
                                    AlwaysStoppedAnimation<Color>(colorWhite),
                              ),
                            ),
                            const SizedBox(width: Dimens.spacingM),
                            Text(
                              appLocalizations.generatingContactTag,
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
                              appLocalizations.generateContactTag,
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

  Widget _buildQrModeSection() {
    return Card(
      color: grey50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        side: BorderSide(color: grey300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.qr_code_2, color: colorAccent, size: 18),
                const SizedBox(width: Dimens.spacingS),
                Text(
                  appLocalizations.qrCodeContent,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeM,
                    fontWeight: FontWeight.w600,
                    color: colorBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacingM),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<ContactQrMode>(
                segments: [
                  ButtonSegment(
                    value: ContactQrMode.vCard,
                    label: Text(appLocalizations.qrContentVcard),
                    icon: const Icon(Icons.contact_phone_outlined, size: 16),
                  ),
                  ButtonSegment(
                    value: ContactQrMode.link,
                    label: Text(appLocalizations.qrContentLink),
                    icon: const Icon(Icons.link_outlined, size: 16),
                  ),
                ],
                selected: {_qrMode},
                onSelectionChanged: (selection) {
                  setState(() {
                    _qrMode = selection.first;
                    _contactData = _buildModel();
                  });
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  side: WidgetStateProperty.all(
                    const BorderSide(color: grey300),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return colorPrimary.withValues(alpha: 0.12);
                    }
                    return colorWhite;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return colorPrimary;
                    }
                    return grey600;
                  }),
                ),
              ),
            ),
            const SizedBox(height: Dimens.spacingS),
            Text(
              _qrMode == ContactQrMode.link
                  ? appLocalizations.qrContentLinkHint
                  : appLocalizations.qrContentVcardHint,
              style: TextStyle(fontSize: Dimens.fontSizeS, color: grey600),
            ),
          ],
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
    int? maxLength = 40,
    FocusNode? focusNode,
    TextInputType? keyboardType,
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
        keyboardType: keyboardType,
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
            color: grey500,
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
          fillColor: grey50,
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Card(
      color: grey50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        side: BorderSide(color: grey300, width: 1),
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
                  color: colorWhite,
                  borderRadius: BorderRadius.circular(Dimens.radiusM),
                  border: Border.all(
                    color: _profileImage != null ? colorPrimary : grey300,
                    width: _profileImage != null ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: grey100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _profileImage != null
                              ? colorPrimary.withValues(alpha: 0.3)
                              : grey300,
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
                                      color: colorWhite,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Icon(
                              Icons.add_photo_alternate,
                              size: 28,
                              color: grey400,
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
                              color: grey600,
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
                            : grey100,
                        borderRadius: BorderRadius.circular(Dimens.radiusRound),
                      ),
                      child: Icon(
                        _profileImage != null
                            ? Icons.edit
                            : Icons.arrow_forward_ios,
                        color: _profileImage != null ? colorPrimary : grey400,
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
