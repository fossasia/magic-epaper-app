import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/util/image_picker_util.dart';
import 'package:magicepaperapp/card_templates/employee_id_card_widget.dart';
import 'package:magicepaperapp/card_templates/employee_id_model.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/util/page_route_util.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/card_templates/util/responsive_layout_util.dart';
import 'package:magicepaperapp/card_templates/util/barcode_scanner_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class EmployeeIdForm extends StatefulWidget {
  final int width;
  final int height;

  const EmployeeIdForm({super.key, required this.width, required this.height});

  @override
  State<EmployeeIdForm> createState() => _EmployeeIdFormState();
}

class _EmployeeIdFormState extends State<EmployeeIdForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _divisionController = TextEditingController();
  final _positionController = TextEditingController();
  final _qrDataController = TextEditingController();

  final Map<String, FocusNode> _fieldFocusNodes = {
    'companyName': FocusNode(),
    'name': FocusNode(),
    'position': FocusNode(),
    'division': FocusNode(),
    'idNumber': FocusNode(),
    'qr': FocusNode(),
  };

  File? _profileImage;
  bool _isGenerating = false;

  late EmployeeIdModel _employeeData;

  @override
  void initState() {
    super.initState();
    _employeeData = EmployeeIdModel(
      companyName: '',
      name: '',
      idNumber: '',
      division: '',
      position: '',
      qrData: '',
    );

    _companyNameController.addListener(_updatePreview);
    _nameController.addListener(_updatePreview);
    _idNumberController.addListener(_updatePreview);
    _divisionController.addListener(_updatePreview);
    _positionController.addListener(_updatePreview);
    _qrDataController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _companyNameController.removeListener(_updatePreview);
    _nameController.removeListener(_updatePreview);
    _idNumberController.removeListener(_updatePreview);
    _divisionController.removeListener(_updatePreview);
    _positionController.removeListener(_updatePreview);
    _qrDataController.removeListener(_updatePreview);

    _companyNameController.dispose();
    _nameController.dispose();
    _idNumberController.dispose();
    _divisionController.dispose();
    _positionController.dispose();
    _qrDataController.dispose();

    for (final node in _fieldFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      _employeeData = EmployeeIdModel(
        companyName: _companyNameController.text,
        name: _nameController.text,
        idNumber: _idNumberController.text,
        division: _divisionController.text,
        position: _positionController.text,
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
    FocusScope.of(context).unfocus();

    setState(() {
      _isGenerating = true;
    });

    try {
      final List<LayerSpec> layers = [];

      final layoutParams =
          ResponsiveLayoutUtil.getEmployeeIdLayout(widget.width, widget.height);

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

      if (_employeeData.companyName.isNotEmpty) {
        layers.add(LayerSpec.text(
          textStyle: TextStyle(
            fontSize: layoutParams.companyNameFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          text: _employeeData.companyName,
          textAlign: TextAlign.center,
          offset: layoutParams.companyNameOffset,
          scale: layoutParams.companyNameScale,
          followCanvasTheme: true,
          elementId: 'companyName',
        ));
      }

      if (_employeeData.name.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.namePrefix}${_employeeData.name}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['name']!,
          scale: layoutParams.textFieldScale,
          followCanvasTheme: true,
          elementId: 'name',
        ));
      }

      if (_employeeData.position.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.positionPrefix}${_employeeData.position}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['position']!,
          scale: layoutParams.textFieldScale,
          followCanvasTheme: true,
          elementId: 'position',
        ));
      }

      if (_employeeData.division.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.divisionPrefix}${_employeeData.division}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['division']!,
          scale: layoutParams.textFieldScale,
          followCanvasTheme: true,
          elementId: 'division',
        ));
      }

      if (_employeeData.idNumber.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.idPrefix}${_employeeData.idNumber}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['idNumber']!,
          scale: layoutParams.textFieldScale,
          followCanvasTheme: true,
          elementId: 'idNumber',
        ));
      }

      if (_employeeData.qrData.isNotEmpty) {
        layers.add(LayerSpec.widget(
          widget: BarcodeWidget(
            padding: const EdgeInsets.all(Dimens.spacingXxs),
            backgroundColor: colorWhite,
            barcode: Barcode.qrCode(),
            data: _employeeData.qrData,
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
      } else if (result is String) {
        _handleEditRequest(result);
      }
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: -1,
      showBackButton: true,
      titleWidget: Text(
        appLocalizations.employeeIdCard,
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
                  appLocalizations.previewIdCard,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacingM),
              EmployeeIdCardWidget(data: _employeeData),
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
                              appLocalizations.idCardDetails,
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
                          appLocalizations.fillDetailsToCreateId,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: Dimens.spacingXl),
                        _buildPhotoSection(),
                        const SizedBox(height: Dimens.spacingXl),
                        _buildTextFormField(
                          controller: _companyNameController,
                          focusNode: _fieldFocusNodes['companyName'],
                          label: appLocalizations.companyName,
                          hint: appLocalizations.enterCompanyName,
                          icon: Icons.business_outlined,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _nameController,
                          focusNode: _fieldFocusNodes['name'],
                          label: appLocalizations.name,
                          hint: appLocalizations.enterEmployeeName,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _positionController,
                          focusNode: _fieldFocusNodes['position'],
                          label: appLocalizations.position,
                          hint: appLocalizations.enterJobPosition,
                          icon: Icons.work_outline,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _divisionController,
                          focusNode: _fieldFocusNodes['division'],
                          label: appLocalizations.division,
                          hint: appLocalizations.enterDepartment,
                          icon: Icons.groups_outlined,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _idNumberController,
                          focusNode: _fieldFocusNodes['idNumber'],
                          label: appLocalizations.idNumber,
                          hint: appLocalizations.enterUniqueId,
                          icon: Icons.badge_outlined,
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
                              appLocalizations.generatingIdCard,
                              style: const TextStyle(
                                  fontSize: Dimens.fontSizeL,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.credit_card, size: 18),
                            const SizedBox(width: Dimens.spacingS),
                            Text(
                              appLocalizations.generateIdCard,
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
