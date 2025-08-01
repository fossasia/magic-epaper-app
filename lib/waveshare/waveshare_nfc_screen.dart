import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/constants/string_constants.dart';
import 'package:magic_epaper_app/view/widget/common_scaffold_widget.dart';
import 'package:magic_epaper_app/waveshare/services/waveshare_nfc_services.dart';

class WaveShareNfcScreen extends StatefulWidget {
  const WaveShareNfcScreen({super.key});

  @override
  State<WaveShareNfcScreen> createState() => _WaveShareNfcScreenState();
}

class _WaveShareNfcScreenState extends State<WaveShareNfcScreen> {
  final ImagePicker _picker = ImagePicker();
  final WaveShareNfcServices _WaveShareNfcServices = WaveShareNfcServices();
  File? _imageFile;
  String _status = 'Pick an image to start';

  final Map<String, Map<String, int>> screenSizes = {
    "2.13\"": {"width": 250, "height": 122, "enum": 0},
    "2.9\"": {"width": 296, "height": 128, "enum": 1},
    "4.2\"": {"width": 400, "height": 300, "enum": 2},
    "7.5\"": {"width": 800, "height": 480, "enum": 3},
    "2.7\"": {"width": 264, "height": 176, "enum": 5},
    "2.9\" V2": {"width": 296, "height": 128, "enum": 6},
    "4.2\" V2": {"width": 400, "height": 300, "enum": 9},
    "7.5\" V2": {"width": 880, "height": 528, "enum": 4},
  };

  String _selectedScreenSize = "2.9\"";

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _status = 'Image selected. Ready to flash.';
      });
    }
  }

  Future<void> _flashImage() async {
    if (_imageFile == null) {
      setState(() {
        _status = 'Please pick an image first.';
      });
      return;
    }

    setState(() {
      _status = 'Processing image...';
    });

    final Uint8List imageBytes = await _imageFile!.readAsBytes();
    final img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      setState(() {
        _status = 'Could not decode image.';
      });
      return;
    }

    final int width = screenSizes[_selectedScreenSize]!['width']!;
    final int height = screenSizes[_selectedScreenSize]!['height']!;
    final int ePaperSizeEnum = screenSizes[_selectedScreenSize]!['enum']!;

    final img.Image resizedImage =
        img.copyResize(originalImage, width: width, height: height);
    final img.Image monochromeImage = img.grayscale(resizedImage);
    final Uint8List processedImageBytes =
        Uint8List.fromList(img.encodePng(monochromeImage));

    setState(() {
      _status = 'Image processed. Hold phone near the display to flash.';
    });

    final String? result = await _WaveShareNfcServices.flashImage(
        processedImageBytes, ePaperSizeEnum);

    setState(() {
      _status = result ?? 'An unknown error occurred.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: StringConstants.appName,
      index: 1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 200,
              ),
            const SizedBox(height: 20),
            Text(_status),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedScreenSize,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedScreenSize = newValue!;
                });
              },
              items: screenSizes.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _flashImage,
              child: const Text('Flash Image'),
            ),
          ],
        ),
      ),
    );
  }
}
