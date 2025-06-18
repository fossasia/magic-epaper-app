import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/pro_image_editor/features/movable_background_image.dart';
import 'package:magic_epaper_app/provider/color_adjustment_provider.dart';
import 'package:magic_epaper_app/provider/color_palette_provider.dart';
import 'package:magic_epaper_app/provider/getitlocator.dart';
import 'package:magic_epaper_app/util/image_editor_utils.dart';
import 'package:magic_epaper_app/view/widget/image_list.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

import 'package:magic_epaper_app/provider/image_loader.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/util/protocol.dart';

final _colors = getIt<ColorPaletteProvider>().colors;

class ImageEditor extends StatefulWidget {
  final Epd epd;
  const ImageEditor({super.key, required this.epd});

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  int _selectedFilterIndex = 0;
  bool flipHorizontal = false;
  bool flipVertical = false;

  img.Image? _processedSourceImage;
  List<img.Image> _rawImages = [];
  List<Uint8List> _processedPngs = [];
  Map<Color, double> _currentWeights = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ColorAdjustmentProvider>().resetWeights(_colors);
    });
  }

  void _onFilterSelected(int index) {
    if (_selectedFilterIndex != index) {
      setState(() {
        _selectedFilterIndex = index;
      });
    }
  }

  void toggleFlipHorizontal() {
    setState(() {
      flipHorizontal = !flipHorizontal;
    });
  }

  void toggleFlipVertical() {
    setState(() {
      flipVertical = !flipVertical;
    });
  }

  void _updateProcessedImages(
      img.Image? sourceImage, Map<Color, double> weights) {
    if (sourceImage == null) {
      if (_rawImages.isNotEmpty) {
        setState(() {
          _processedSourceImage = null;
          _rawImages = [];
          _processedPngs = [];
        });
      }
      return;
    }

    if (_processedSourceImage == sourceImage &&
        _currentWeights.toString() == weights.toString()) {
      return;
    }

    _rawImages = processImages(
      originalImage: sourceImage,
      epd: widget.epd,
      weights: weights,
    );

    _processedPngs = _rawImages
        .map((rawImg) => img.encodePng(img.copyRotate(rawImg, angle: 90)))
        .toList();

    setState(() {
      _processedSourceImage = sourceImage;
      _currentWeights = weights;
      if (_processedSourceImage != sourceImage) {
        _selectedFilterIndex = 0;
        flipHorizontal = false;
        flipVertical = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var imgLoader = context.watch<ImageLoader>();
    var colorAdjuster = context.watch<ColorAdjustmentProvider>();

    if (imgLoader.image != null && colorAdjuster.weights.isEmpty) {
      colorAdjuster.resetWeights(_colors);
    }

    _updateProcessedImages(imgLoader.image, colorAdjuster.weights);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colorAccent,
        elevation: 0,
        title: const Text(
          'Select a Filter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          if (_rawImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TextButton(
                onPressed: () {
                  img.Image finalImg = _rawImages[_selectedFilterIndex];

                  if (flipHorizontal) {
                    finalImg = img.flipHorizontal(finalImg);
                  }
                  if (flipVertical) {
                    finalImg = img.flipVertical(finalImg);
                  }
                  Protocol(epd: widget.epd).writeImages(finalImg);
                },
                style: TextButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white, width: 1),
                  ),
                ),
                child: const Text('Transfer'),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _processedPngs.isNotEmpty
              ? ImageList(
                  key: ValueKey(_processedSourceImage),
                  processedPngs: _processedPngs,
                  epd: widget.epd,
                  selectedIndex: _selectedFilterIndex,
                  flipHorizontal: flipHorizontal,
                  flipVertical: flipVertical,
                  onFilterSelected: _onFilterSelected,
                  onFlipHorizontal: toggleFlipHorizontal,
                  onFlipVertical: toggleFlipVertical,
                )
              : const Center(
                  child: Text(
                    "Import an image to begin",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: BottomActionMenu(
        epd: widget.epd,
        imgLoader: imgLoader,
        colors: _colors,
      ),
    );
  }
}

class BottomActionMenu extends StatelessWidget {
  final Epd epd;
  final ImageLoader imgLoader;
  final List<Color> colors;

  const BottomActionMenu({
    super.key,
    required this.epd,
    required this.imgLoader,
    required this.colors,
  });

  void _showColorAdjustmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) => ColorAdjustmentSliders(colors: colors),
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorAdjuster = context.watch<ColorAdjustmentProvider>();
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildActionButton(
                context: context,
                icon: Icons.add_photo_alternate_outlined,
                label: 'Import New',
                onTap: () {
                  imgLoader.pickImage(width: epd.width, height: epd.height);
                  colorAdjuster.resetWeights(_colors);
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.edit_outlined,
                label: 'Open Editor',
                onTap: () async {
                  final canvasBytes =
                      await Navigator.of(context).push<Uint8List>(
                    MaterialPageRoute(
                      builder: (context) =>
                          const MovableBackgroundImageExample(),
                    ),
                  );
                  if (canvasBytes != null) {
                    colorAdjuster.resetWeights(_colors);
                    imgLoader.updateImage(
                      bytes: canvasBytes,
                      width: epd.width,
                      height: epd.height,
                    );
                  }
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.tune_rounded,
                label: 'Adjust',
                onTap: () async {
                  if (imgLoader.image != null) {
                    final canvasBytes = await Navigator.of(context)
                        .push<Uint8List>(MaterialPageRoute(
                      builder: (context) => ProImageEditor.memory(
                        img.encodeJpg(imgLoader.image!),
                        callbacks: ProImageEditorCallbacks(
                          onImageEditingComplete: (Uint8List bytes) async {
                            Navigator.pop(context, bytes);
                          },
                        ),
                        configs: const ProImageEditorConfigs(
                          paintEditor: PaintEditorConfigs(enabled: false),
                          textEditor: TextEditorConfigs(enabled: false),
                          cropRotateEditor: CropRotateEditorConfigs(
                            enabled: false,
                          ),
                          emojiEditor: EmojiEditorConfigs(enabled: false),
                        ),
                      ),
                    ));
                    if (canvasBytes != null) {
                      imgLoader.updateImage(
                        bytes: canvasBytes,
                        width: epd.width,
                        height: epd.height,
                      );
                      colorAdjuster.resetWeights(_colors);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          duration: Durations.medium4,
                          content: Text('Import an image first!'),
                          backgroundColor: colorPrimary),
                    );
                  }
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.palette_outlined,
                label: 'Adjust Colors',
                onTap: () {
                  if (imgLoader.image != null) {
                    _showColorAdjustmentSheet(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          duration: Durations.medium4,
                          content: Text('Import an image first!'),
                          backgroundColor: colorPrimary),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colorAccent, size: 26),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(color: colorBlack, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorAdjustmentSliders extends StatefulWidget {
  final List<Color> colors;
  const ColorAdjustmentSliders({super.key, required this.colors});

  @override
  State<ColorAdjustmentSliders> createState() => _ColorAdjustmentSlidersState();
}

class _ColorAdjustmentSlidersState extends State<ColorAdjustmentSliders> {
  late Map<Color, double> _localWeights;

  @override
  void initState() {
    super.initState();
    _localWeights = Map<Color, double>.from(
        context.read<ColorAdjustmentProvider>().weights);
  }

  String _getColorName(Color color) {
    if (color == Colors.black) return 'Black';
    if (color == Colors.white) return 'White';
    if (color == Colors.red) return 'Red';
    return 'Color';
  }

  @override
  Widget build(BuildContext context) {
    final colorAdjuster = context.read<ColorAdjustmentProvider>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Adjust Color Intensity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...widget.colors.map((color) {
            return Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                ),
                const SizedBox(width: 12),
                Text(_getColorName(color),
                    style: const TextStyle(fontSize: 16)),
                Expanded(
                  child: Slider(
                    value: _localWeights[color] ?? 1.0,
                    min: 0.0,
                    max: 10.0,
                    divisions: 30,
                    label: (_localWeights[color] ?? 1.0).toStringAsFixed(1),
                    activeColor: colorAccent,
                    onChanged: (newValue) {
                      setState(() {
                        _localWeights[color] = newValue;
                      });
                    },
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    for (var key in _localWeights.keys) {
                      _localWeights[key] = 1.0;
                    }
                  });
                },
                child: const Text('Reset'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  colorAdjuster.updateWeights(_localWeights);
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
