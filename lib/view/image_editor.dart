import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/pro_image_editor/features/movable_background_image.dart';
import 'package:magic_epaper_app/util/image_editor_utils.dart';
import 'package:magic_epaper_app/util/xbm_encoder.dart';
import 'package:magic_epaper_app/view/widget/image_list.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

import 'package:magic_epaper_app/provider/image_loader.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';
import 'package:magic_epaper_app/util/protocol.dart';

class ImageEditor extends StatefulWidget {
  final Epd epd;
  final bool isExportOnly;
  const ImageEditor({super.key, required this.epd, this.isExportOnly = false});

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final imgLoader = context.read<ImageLoader>();
      if (imgLoader.image == null) {
        imgLoader.loadFinalizedImage(
          width: widget.epd.width,
          height: widget.epd.height,
        );
      }
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

  void _updateProcessedImages(img.Image? sourceImage) {
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

    if (_processedSourceImage == sourceImage) {
      return;
    }

    _rawImages = processImages(originalImage: sourceImage, epd: widget.epd);

    _processedPngs = _rawImages
        .map((rawImg) => img.encodePng(img.copyRotate(rawImg, angle: 90)))
        .toList();

    setState(() {
      _processedSourceImage = sourceImage;
      _selectedFilterIndex = 0;
      flipHorizontal = false;
      flipVertical = false;
    });
  }

  /// Gets a simple string name for a color, used for filenames.
  String _getColorName(Color color) {
    if (color == Colors.black) return 'black';
    if (color == Colors.red) return 'red';
    if (color == Colors.yellow) return 'yellow';
    if (color == Colors.blue) return 'blue';
    if (color == Colors.green) return 'green';
    // Fallback for other colors.
    return color.toARGB32().toRadixString(16);
  }

  /// Handles the logic for exporting the processed image as XBM files.
  Future<void> _exportXbmFiles() async {
    if (_rawImages.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Exporting XBM files...'),
      ),
    );

    try {
      img.Image baseImage = _rawImages[_selectedFilterIndex];

      // Apply flips to the base image before extracting color planes.
      if (flipHorizontal) {
        baseImage = img.flipHorizontal(baseImage);
      }
      if (flipVertical) {
        baseImage = img.flipVertical(baseImage);
      }

      // We only export non-white colors.
      final nonWhiteColors = widget.epd.colors.where((c) => c != Colors.white);

      int exportedCount = 0;
      //print(nonWhiteColors);
      for (final color in nonWhiteColors) {
        final colorName = _getColorName(color);
        final variableName = 'image_$colorName';

        // Extract the monochrome image for the current color plane.
        final colorPlaneImage = widget.epd.extractColorPlaneAsImage(
          color,
          baseImage,
        );

        // Encode the monochrome image to the XBM format.
        final xbmContent = XbmEncoder.encode(colorPlaneImage, variableName);

        // Save the generated string as a file.
        await FileSaver.instance.saveFile(
          name: variableName,
          bytes: Uint8List.fromList(xbmContent.codeUnits),
          ext: 'xbm',
          mimeType: MimeType.text,
        );
        exportedCount++;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text('$exportedCount XBM file(s) exported successfully!'),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var imgLoader = context.watch<ImageLoader>();
    _updateProcessedImages(imgLoader.image);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: colorAccent,
        elevation: 0,
        title: const Text(
          StringConstants.filterScreenTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          if (_rawImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TextButton(
                onPressed: widget.isExportOnly
                    ? _exportXbmFiles
                    : () {
                        _exportXbmFiles();
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
                child: widget.isExportOnly
                    ? const Text('Export XBM')
                    : const Text(StringConstants.transferButtonLabel),
              ),
            ),
        ],
      ),
      body: imgLoader.isLoading
          ? const Center(
              child: Text(
                'Loading...',
                style: TextStyle(color: colorBlack, fontSize: 14),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _processedPngs.isNotEmpty
                    ? ImageList(
                        key: ValueKey(_processedSourceImage),
                        processedPngs: _processedPngs,
                        epd: widget.epd,
                        width: widget.epd.width,
                        height: widget.epd.height,
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
      ),
    );
  }
}

class BottomActionMenu extends StatelessWidget {
  final Epd epd;
  final ImageLoader imgLoader;

  const BottomActionMenu({
    super.key,
    required this.epd,
    required this.imgLoader,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: .1),
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
                label: StringConstants.importImageButtonLabel,
                onTap: () async {
                  final success = await imgLoader.pickImage(
                    width: epd.width,
                    height: epd.height,
                  );
                  if (success && imgLoader.image != null) {
                    final bytes = Uint8List.fromList(
                      img.encodePng(imgLoader.image!),
                    );
                    await imgLoader.saveFinalizedImageBytes(bytes);
                  }
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.edit_outlined,
                label: StringConstants.openEditor,
                onTap: () async {
                  final canvasBytes =
                      await Navigator.of(context).push<Uint8List>(
                    MaterialPageRoute(
                      builder: (context) => MovableBackgroundImageExample(
                        width: epd.width,
                        height: epd.height,
                      ),
                    ),
                  );
                  if (canvasBytes != null) {
                    await imgLoader.updateImage(
                      bytes: canvasBytes,
                      width: epd.width,
                      height: epd.height,
                    );
                    await imgLoader.saveFinalizedImageBytes(canvasBytes);
                  }
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.tune_rounded,
                label: StringConstants.adjustButtonLabel,
                onTap: () async {
                  if (imgLoader.image != null) {
                    final canvasBytes =
                        await Navigator.of(context).push<Uint8List>(
                      MaterialPageRoute(
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
                      ),
                    );
                    if (canvasBytes != null) {
                      imgLoader.updateImage(
                        bytes: canvasBytes,
                        width: epd.width,
                        height: epd.height,
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Durations.medium4,
                        content: Text(StringConstants.noImageSelectedFeedback),
                        backgroundColor: colorPrimary,
                      ),
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
              Text(
                label,
                style: const TextStyle(color: colorBlack, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
