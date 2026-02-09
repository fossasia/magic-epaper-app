import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/card_templates/employee_id_card_widget.dart';
import 'package:magicepaperapp/card_templates/employee_id_model.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/pro_image_editor/features/movable_background_image.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/card_templates/util/responsive_layout_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
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
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _updatePreview();
      });
    }
  }

  void _submitForm() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final List<LayerSpec> layers = [];

      final layoutParams =
          ResponsiveLayoutUtil.getEmployeeIdLayout(widget.width, widget.height);

      if (_profileImage != null) {
        layers.add(LayerSpec.widget(
          widget: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.file(_profileImage!,
                width: 200, height: 200, fit: BoxFit.cover),
          ),
          offset: layoutParams.profileImageOffset,
          scale: layoutParams.profileImageScale,
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
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.center,
          offset: layoutParams.companyNameOffset,
          scale: layoutParams.companyNameScale,
        ));
      }

      if (_employeeData.name.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.namePrefix}${_employeeData.name}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['name']!,
          scale: layoutParams.textFieldScale,
        ));
      }

      if (_employeeData.position.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.positionPrefix}${_employeeData.position}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['position']!,
          scale: layoutParams.textFieldScale,
        ));
      }

      if (_employeeData.division.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.divisionPrefix}${_employeeData.division}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['division']!,
          scale: layoutParams.textFieldScale,
        ));
      }

      if (_employeeData.idNumber.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${appLocalizations.idPrefix}${_employeeData.idNumber}',
          textStyle: TextStyle(fontSize: layoutParams.textFieldFontSize),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          textAlign: TextAlign.left,
          offset: layoutParams.textOffsets['idNumber']!,
          scale: layoutParams.textFieldScale,
        ));
      }

      if (_employeeData.qrData.isNotEmpty) {
        layers.add(LayerSpec.widget(
          widget: BarcodeWidget(
            padding: const EdgeInsets.all(2),
            backgroundColor: colorWhite,
            barcode: Barcode.qrCode(),
            data: _employeeData.qrData,
            width: layoutParams.qrCodeSize.width,
            height: layoutParams.qrCodeSize.height,
          ),
          offset: layoutParams.qrCodeOffset,
          scale: layoutParams.qrCodeScale,
        ));
      }

      final result = await Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(
          builder: (context) => MovableBackgroundImageExample(
            width: widget.width,
            height: widget.height,
            initialLayers: layers,
          ),
        ),
      );

      if (result != null) {
        Navigator.of(context)
          ..pop()
          ..pop(result);
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
      toolbarHeight: 85,
      titleWidget: Padding(
        padding: const EdgeInsets.fromLTRB(5, 16, 16, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.employeeIdCard,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              appLocalizations.fillDetailsToCreateId,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 14, 16.0, 16.0),
          child: Column(
            children: [
              EmployeeIdCardWidget(data: _employeeData),
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
                              appLocalizations.idCardDetails,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildPhotoSection(),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          controller: _companyNameController,
                          label: appLocalizations.companyName,
                          hint: appLocalizations.enterCompanyName,
                          icon: Icons.business_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _nameController,
                          label: appLocalizations.name,
                          hint: appLocalizations.enterEmployeeName,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _positionController,
                          label: appLocalizations.position,
                          hint: appLocalizations.enterJobPosition,
                          icon: Icons.work_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _divisionController,
                          label: appLocalizations.division,
                          hint: appLocalizations.enterDepartment,
                          icon: Icons.groups_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _idNumberController,
                          label: appLocalizations.idNumber,
                          hint: appLocalizations.enterUniqueId,
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _qrDataController,
                          label: appLocalizations.qrCodeData,
                          hint: appLocalizations.enterQrCodeData,
                          icon: Icons.qr_code_outlined,
                          maxLines: 2,
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
                    shadowColor: colorPrimary.withOpacity(0.3),
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
                              appLocalizations.generatingIdCard,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.credit_card, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              appLocalizations.generateIdCard,
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
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorPrimary,
          selectionColor: colorPrimary.withOpacity(0.2),
          selectionHandleColor: colorPrimary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: colorPrimary,
          hoverColor: colorPrimary.withOpacity(0.1),
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 16,
          color: colorBlack,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: colorPrimary,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: colorAccent, size: 20),
          labelStyle: TextStyle(
            color: colorBlack.withOpacity(0.7),
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
                      color: colorPrimary.withOpacity(0.1),
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
              splashColor: colorAccent.withOpacity(0.1),
              highlightColor: colorAccent.withOpacity(0.05),
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
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _profileImage != null
                              ? colorPrimary.withOpacity(0.3)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: _profileImage != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
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
                            ? colorPrimary.withOpacity(0.1)
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
