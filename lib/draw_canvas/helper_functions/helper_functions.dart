import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magic_epaper_app/draw_canvas/Dialogs/add_text_overlay_dialog.dart';
import 'package:magic_epaper_app/draw_canvas/Dialogs/build_image_preview_dialog.dart';
import 'package:magic_epaper_app/draw_canvas/Dialogs/pick_color_dialog.dart';
import 'package:magic_epaper_app/draw_canvas/Dialogs/show_layer_manager_dialog.dart';
import 'package:magic_epaper_app/draw_canvas/models/overlay_item.dart';
import 'package:magic_epaper_app/draw_canvas/view/image_adjust_page.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';

Future<void> pickColorDialog(BuildContext context, Color selectedColor,
    ValueChanged<Color> onColorPicked) async {
  showDialog(
    context: context,
    builder: (_) =>
        buildColorPickerDialog(context, selectedColor, onColorPicked),
  );
}

void addTextOverlayDialog({
  required BuildContext context,
  required Color selectedColor,
  required void Function(OverlayItem) onItemCreated,
}) {
  showDialog(
    context: context,
    builder: (_) => buildTextOverlayDialog(
      context: context,
      selectedColor: selectedColor,
      onItemCreated: onItemCreated,
    ),
  );
}

void showLayerManagerModal({
  required BuildContext context,
  required List<OverlayItem> items,
  required void Function(int oldIndex, int newIndex) onReorder,
}) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return buildLayerManagerDialog(
            items: items,
            onReorder: onReorder,
            setModalState: setModalState,
          );
        },
      );
    },
  );
}

Future<void> pickImageFromGallery({
  required void Function(OverlayItem) onImagePicked,
}) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final bytes = await image.readAsBytes();
    final name = image.name;

    onImagePicked(
      OverlayItem.image(
        imageBytes: bytes,
        label: name,
      ),
    );
  }
}

Future<void> captureAndProcessImage({
  required BuildContext context,
  required ScreenshotController controller,
  required Epd epd,
  required void Function(Uint8List adjustedBytes) onImageExported,
  required void Function() onCaptureStart,
  required void Function() onCaptureEnd,
}) async {
  onCaptureStart();

  await Future.delayed(const Duration(milliseconds: 100));
  final image = await controller.capture();

  onCaptureEnd();

  if (image == null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Failed to capture image")));
    return;
  }

  showDialog(
    context: context,
    builder: (_) => buildImagePreviewDialog(
      context: context,
      image: image,
      onSubmit: () async {
        final tempDir = await getTemporaryDirectory();
        final tempPath = '${tempDir.path}/captured_image.png';
        final file = await File(tempPath).writeAsBytes(image);

        final croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatio: CropAspectRatio(
            ratioX: epd.width.toDouble(),
            ratioY: epd.height.toDouble(),
          ),
        );

        if (croppedFile != null) {
          final croppedBytes = await File(croppedFile.path).readAsBytes();
          final adjustedBytes = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ImageAdjustScreen(imageBytes: croppedBytes),
            ),
          );

          if (adjustedBytes != null) {
            onImageExported(adjustedBytes);
          }
        }
      },
    ),
  );
}
