import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:magic_epaper_app/employee_id_generator/widgets/dialogs/id_card_preview_dialog.dart';
import 'package:magic_epaper_app/employee_id_generator/widgets/dialogs/image_source_dialog.dart';
import 'package:magic_epaper_app/employee_id_generator/widgets/dialogs/remove_image_dialog.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';

class EmployeeIdController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  bool _isGenerating = false;
  Uint8List? _profileImage;

  bool get isGenerating => _isGenerating;
  Uint8List? get profileImage => _profileImage;

  EmployeeIdController() {
    companyController.text = StringConstants.defaultCompanyName;

    nameController.addListener(notifyListeners);
    idController.addListener(notifyListeners);
    designationController.addListener(notifyListeners);
    departmentController.addListener(notifyListeners);
    emailController.addListener(notifyListeners);
    phoneController.addListener(notifyListeners);
    companyController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    designationController.dispose();
    departmentController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyController.dispose();
    super.dispose();
  }

  void _setGenerating(bool value) {
    _isGenerating = value;
    notifyListeners();
  }

  void _setProfileImage(Uint8List? image) {
    _profileImage = image;
    notifyListeners();
  }

  Future<void> pickProfileImage(BuildContext context) async {
    try {
      final ImageSource? source = await _showImageSourceDialog(context);
      if (source == null) return;
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        _setProfileImage(imageBytes);
        _showSuccessSnackBar(
            context, StringConstants.profileImageUpdatedSuccess);
      }
    } catch (e) {
      _showErrorSnackBar(context, '${StringConstants.errorPickingImage}$e');
    }
  }

  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return showDialog<ImageSource>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ImageSourceDialog();
      },
    );
  }

  Future<void> removeProfileImage(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const RemoveProfileImageDialog();
      },
    );
    if (confirm == true) {
      _setProfileImage(null);
      _showRemoveSnackBar(context, StringConstants.profileImageRemovedSuccess);
    }
  }

  Future<Uint8List?> generateIdCard(
    BuildContext context,
    GlobalKey formKey,
    GlobalKey cardKey,
    int epdHeight,
    int epdWidth,
  ) async {
    final FormState? formState = formKey.currentState as FormState?;
    if (formState == null || !formState.validate()) return null;

    _setGenerating(true);

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final RenderRepaintBoundary? boundary =
          cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception(StringConstants.idCardWidgetNotFound);
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final img.Image? decodedImage = img.decodeImage(pngBytes);

        if (decodedImage != null) {
          final Uint8List? confirmedImageBytes = await _showImagePreview(
              context, decodedImage, epdHeight, epdWidth);
          return confirmedImageBytes;
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, '${StringConstants.errorGeneratingIdCard}$e');
    } finally {
      _setGenerating(false);
    }

    return null;
  }

  Future<Uint8List?> _showImagePreview(
    BuildContext context,
    img.Image originalImage,
    int epdHeight,
    int epdWidth, {
    String? title,
    String? subtitle,
  }) async {
    return await showDialog<Uint8List?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PreviewDialog(
          originalImage: originalImage,
          epdHeight: epdHeight,
          epdWidth: epdWidth,
          title: title,
          subtitle: subtitle,
        );
      },
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showRemoveSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.delete,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
