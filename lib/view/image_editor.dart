import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/employee_id_generator/employee_id_generator_screen.dart';
import 'package:magic_epaper_app/image_library/provider/image_library_provider.dart';
import 'package:magic_epaper_app/image_library/services/image_save_handler.dart';
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

  String _currentImageSource = 'imported';
  img.Image? _processedSourceImage;
  List<img.Image> _rawImages = [];
  List<img.Image> _rotatedImages = [];
  List<Uint8List> _processedPngs = [];
  ImageSaveHandler? _imageSaveHandler;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageSaveHandler = ImageSaveHandler(
      context: context,
      provider: context.read<ImageLibraryProvider>(),
    );
  }

  // Navigate to Image Library using ImageSaveHandler
  Future<void> _navigateToImageLibrary() async {
    await _imageSaveHandler!.navigateToImageLibrary();
  }

  // Save image using ImageSaveHandler
  void _saveCurrentImage() async {
    if (_imageSaveHandler == null) return;

    await _imageSaveHandler!.saveCurrentImage(
      rawImages: _rotatedImages,
      selectedFilterIndex: _selectedFilterIndex,
      flipHorizontal: flipHorizontal,
      flipVertical: flipVertical,
      currentImageSource: _currentImageSource,
      processingMethods: widget.epd.processingMethods,
      modelId: widget.epd.modelId,
    );
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
          _rotatedImages = [];
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

    _rotatedImages =
        _rawImages.map((rawImg) => img.copyRotate(rawImg, angle: 90)).toList();
    _processedPngs =
        _rotatedImages.map((rotatedImg) => img.encodePng(rotatedImg)).toList();

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
          IconButton(
            onPressed: _navigateToImageLibrary,
            icon: const Icon(Icons.photo_library_outlined),
            tooltip: 'Image Library',
          ),
          if (_rawImages.isNotEmpty) ...[
            IconButton(
              onPressed: _saveCurrentImage,
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save to Library',
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
                child: const Text(StringConstants.transferButtonLabel),
              ),
            ),
          ],
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
          imageSaveHandler: _imageSaveHandler,
          onSourceChanged: (String source) {
            setState(() {
              _currentImageSource = source;
            });
          }),
    );
  }
}

class BottomActionMenu extends StatelessWidget {
  final Epd epd;
  final ImageLoader imgLoader;
  final ImageSaveHandler? imageSaveHandler;
  final Function(String)? onSourceChanged;

  const BottomActionMenu({
    super.key,
    required this.epd,
    required this.imgLoader,
    required this.imageSaveHandler,
    this.onSourceChanged,
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
                  onSourceChanged?.call('imported');
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
                    onSourceChanged?.call('editor');
                  }
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.badge_outlined,
                label: 'ID Card',
                onTap: () async {
                  final idCardBytes =
                      await Navigator.of(context).push<Uint8List>(
                    MaterialPageRoute(
                      builder: (context) => EmployeeIdGeneratorScreen(epd: epd),
                    ),
                  );
                  if (idCardBytes != null) {
                    await imgLoader.updateImage(
                      bytes: idCardBytes,
                      width: epd.width,
                      height: epd.height,
                    );
                    await imgLoader.saveFinalizedImageBytes(idCardBytes);
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
              _buildActionButton(
                context: context,
                icon: Icons.photo_library_outlined,
                label: 'Library',
                onTap: () async {
                  await imageSaveHandler?.navigateToImageLibrary();
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
