import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/pro_image_editor/features/movable_background_image.dart';
import 'package:magic_epaper_app/util/image_editor_utils.dart';
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
  const ImageEditor({super.key, required this.epd});

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  int _selectedFilterIndex = 0;
  bool flipHorizontal = false;
  bool flipVertical = false;
  bool isQuickLutEnabled = false;

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

    _rawImages = processImages(
      originalImage: sourceImage,
      epd: widget.epd,
    );

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

  @override
  Widget build(BuildContext context) {
    var imgLoader = context.watch<ImageLoader>();
    _updateProcessedImages(imgLoader.image);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colorAccent,
        elevation: 0,
        title: const Text(
          StringConstants.filterScreenTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          if (_rawImages.isNotEmpty)
            Row(
              children: [
                IconButton(
                  tooltip: isQuickLutEnabled ? 'Quick Mode' : 'Normal Mode',
                  onPressed: () {
                    setState(() {
                      isQuickLutEnabled = !isQuickLutEnabled;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Durations.medium3,
                        content: Text(
                          isQuickLutEnabled
                              ? "Quick Refresh Enabled"
                              : "Normal Refresh Enabled",
                        ),
                        backgroundColor: colorPrimary,
                      ),
                    );
                  },
                  icon: Icon(
                    isQuickLutEnabled ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                ),
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
                      Protocol(epd: widget.epd).writeImages(finalImg,
                          useQuickLut: isQuickLutEnabled);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: colorAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: const Text(StringConstants.transferButtonLabel),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: imgLoader.isLoading
          ? const Center(
              child: Text('Loading...',
                  style: TextStyle(
                    color: colorBlack,
                    fontSize: 14,
                  )))
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
                      width: epd.width, height: epd.height);
                  if (success && imgLoader.image != null) {
                    final bytes =
                        Uint8List.fromList(img.encodePng(imgLoader.image!));
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
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          duration: Durations.medium4,
                          content:
                              Text(StringConstants.noImageSelectedFeedback),
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
