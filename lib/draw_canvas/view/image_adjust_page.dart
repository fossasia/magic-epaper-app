import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:magic_epaper_app/draw_canvas/ImageAdjust/process_image.dart';
import 'package:magic_epaper_app/draw_canvas/ImageAdjust/image_adjust_parms.dart';

class ImageAdjustScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const ImageAdjustScreen({Key? key, required this.imageBytes})
      : super(key: key);

  @override
  State<ImageAdjustScreen> createState() => _ImageAdjustScreenState();
}

class _ImageAdjustScreenState extends State<ImageAdjustScreen> {
  double brightness = 1.0;
  double contrast = 1.0;
  late img.Image fullResImage;

  Uint8List? processedBytes;
  late img.Image originalImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    decodeAndProcess();
  }

  Future<void> decodeAndProcess() async {
    fullResImage = img.decodeImage(widget.imageBytes)!;
    originalImage = img.copyResize(fullResImage, width: 512);
    await applyAdjustments();
  }

  Future<void> applyAdjustments() async {
    setState(() => isLoading = true);

    final resultBytes = await compute(
      processImage,
      ImageAdjustParams(
        originalImage,
        brightness,
        contrast,
      ),
    );

    if (mounted) {
      setState(() {
        processedBytes = resultBytes;
        isLoading = false;
      });
    }
  }

  Timer? debounceTimer;

  void onSliderChanged({double? b, double? c}) {
    if (b != null) brightness = b;
    if (c != null) contrast = c;

    debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      applyAdjustments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adjust Image")),
      body: Column(
        children: [
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (processedBytes != null)
            Expanded(child: Image.memory(processedBytes!)),
          const SizedBox(height: 10),
          Text("Brightness"),
          Slider(
            value: brightness,
            min: 0.0,
            max: 2.0,
            divisions: 20,
            label: brightness.toStringAsFixed(2),
            onChanged: (val) => onSliderChanged(b: val),
          ),
          Text("Contrast"),
          Slider(
            value: contrast,
            min: 0.0,
            max: 2.0,
            divisions: 30,
            label: contrast.toStringAsFixed(2),
            onChanged: (val) => onSliderChanged(c: val),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final fullProcessedBytes = await compute(
                    processImage,
                    ImageAdjustParams(
                      fullResImage,
                      brightness,
                      contrast,
                    ),
                  );

                  Navigator.pop(context, fullProcessedBytes);
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
