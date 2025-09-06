import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/image_library/services/image_save_handler.dart';
import 'package:magicepaperapp/pro_image_editor/features/movable_background_image.dart';
import 'package:magicepaperapp/card_templates/card_template_selection_view.dart';
import 'package:magicepaperapp/util/color_util.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/image_editor_utils.dart';
import 'package:magicepaperapp/util/xbm_encoder.dart';
import 'package:magicepaperapp/view/widget/image_list.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/provider/image_loader.dart';
import 'package:magicepaperapp/util/epd/epd.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class ImageEditor extends StatefulWidget {
  final DisplayDevice device;
  final bool isExportOnly;
  const ImageEditor(
      {super.key, required this.device, this.isExportOnly = false});

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  int _selectedFilterIndex = 0;
  bool flipHorizontal = false;
  bool flipVertical = false;
  Waveform? _selectedWaveform;
  String? _selectedWaveformName;

  String _currentImageSource = 'imported';
  img.Image? _processedSourceImage;
  List<img.Image> _rawImages = [];
  List<img.Image> _rotatedImages = [];
  List<Uint8List> _processedPngs = [];
  ImageSaveHandler? _imageSaveHandler;

  @override
  void initState() {
    setPortraitOrientation();
    super.initState();
    _selectedWaveform = null;
    _selectedWaveformName = null;

    Future.microtask(() {
      loadInitialImage();
    });
  }

  Future<void> loadInitialImage() async {
    final imgLoader = context.read<ImageLoader>();
    if (imgLoader.image == null) {
      await imgLoader.loadFinalizedImage(
        width: widget.device.width,
        height: widget.device.height,
      );
    }
    if (imgLoader.image == null) {
      loadDefaultImage(imgLoader);
    }
  }

  Future<void> loadDefaultImage(ImageLoader imgLoader) async {
    const assetPath = 'assets/images/FOSSASIA.png';
    final byteData = await rootBundle.load(assetPath);
    final pngBytes = byteData.buffer.asUint8List();
    await imgLoader.updateImage(
      bytes: pngBytes,
      width: widget.device.width,
      height: widget.device.height,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageSaveHandler = ImageSaveHandler(
      context: context,
      provider: context.read<ImageLibraryProvider>(),
    );
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
      processingMethods: widget.device.processingMethods,
      modelId: widget.device.modelId,
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

    _rawImages = processImages(originalImage: sourceImage, epd: widget.device);

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

  Future<void> _exportXbmFiles() async {
    if (_rawImages.isEmpty) return;

    final now = DateTime.now();
    final timestamp =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}";

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(appLocalizations.exportingXbm),
      ),
    );

    try {
      img.Image baseImage = _rawImages[_selectedFilterIndex];

      if (flipHorizontal) {
        baseImage = img.flipHorizontal(baseImage);
      }
      if (flipVertical) {
        baseImage = img.flipVertical(baseImage);
      }

      final nonWhiteColors =
          widget.device.colors.where((c) => c != Colors.white);

      int exportedCount = 0;
      for (final color in nonWhiteColors) {
        final colorName = ColorUtils.getColorFileName(color);
        final variableName = 'image_$colorName';

        final colorPlaneImage = widget.device.extractColorPlaneAsImage(
          color,
          baseImage,
        );

        final xbmContent = XbmEncoder.encode(colorPlaneImage, variableName);

        await FileSaver.instance.saveFile(
          name: '${variableName}_$timestamp',
          bytes: Uint8List.fromList(xbmContent.codeUnits),
          fileExtension: 'xbm',
          mimeType: MimeType.text,
        );
        exportedCount++;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(
              '${appLocalizations.exported} $exportedCount ${appLocalizations.xbmFilesToMagicEpaper}'),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text('${appLocalizations.exportFailed}: $e')));
    }
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
        titleSpacing: 0.0,
        backgroundColor: colorAccent,
        elevation: 0,
        title: Text(
          appLocalizations.filterScreenTitle,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.8),
        ),
        actions: [
          if (_rawImages.isNotEmpty) ...[
            if (widget.device is Epd && !widget.isExportOnly)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Builder(builder: (context) {
                  final epd = widget.device as Epd;
                  final List<DropdownMenuItem<String?>> dropdownItems = [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(appLocalizations.fullRefresh),
                    ),
                    ...epd.controller.waveforms.map((waveform) {
                      return DropdownMenuItem<String?>(
                        value: waveform.name,
                        child: Text(
                          waveform.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                  ];

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: _selectedWaveformName,
                        hint: Text(
                          appLocalizations.fullRefresh,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        isDense: true,
                        dropdownColor: colorAccent,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        borderRadius: BorderRadius.circular(8),
                        icon: const SizedBox.shrink(),
                        items: dropdownItems,
                        onChanged: (String? newName) {
                          setState(() {
                            _selectedWaveformName = newName;
                            if (newName == null) {
                              _selectedWaveform = null;
                            } else {
                              _selectedWaveform = epd.controller.waveforms
                                  .firstWhere((w) => w.name == newName);
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Durations.medium3,
                              content: Text(
                                _selectedWaveform == null
                                    ? appLocalizations.fullRefreshSelected
                                    : "${appLocalizations.waveformSelected} ${_selectedWaveform!.name}",
                              ),
                              backgroundColor: colorPrimary,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TextButton(
                onPressed: widget.isExportOnly
                    ? _exportXbmFiles
                    : () async {
                        img.Image finalImg = _rawImages[_selectedFilterIndex];

                        if (flipHorizontal) {
                          finalImg = img.flipHorizontal(finalImg);
                        }
                        if (flipVertical) {
                          finalImg = img.flipVertical(finalImg);
                        }
                        await widget.device.transfer(
                          context,
                          finalImg,
                          waveform: _selectedWaveform,
                        );
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
                    ? Text(appLocalizations.exportXbm)
                    : Text(appLocalizations.transferButtonLabel),
              ),
            ),
          ],
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: imgLoader.isLoading
            ? Center(
                child: Text(
                  appLocalizations.loading,
                  style: const TextStyle(color: colorBlack, fontSize: 14),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _processedPngs.isNotEmpty
                    ? ImageList(
                        key: ValueKey(_processedSourceImage),
                        processedPngs: _processedPngs,
                        epd: widget.device,
                        width: widget.device.width,
                        height: widget.device.height,
                        selectedIndex: _selectedFilterIndex,
                        flipHorizontal: flipHorizontal,
                        flipVertical: flipVertical,
                        onFilterSelected: _onFilterSelected,
                        onFlipHorizontal: toggleFlipHorizontal,
                        onFlipVertical: toggleFlipVertical,
                        onSave: _saveCurrentImage,
                      )
                    : Center(
                        child: Text(
                          appLocalizations.importStartingImageFeedback,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
              ),
      ),
      bottomNavigationBar: BottomActionMenu(
          epd: widget.device,
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
  final DisplayDevice epd;
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
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context: context,
                icon: Icons.add_photo_alternate_outlined,
                label: "Import",
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
                  onSourceChanged?.call('imported');
                },
              ),
              _buildActionButton(
                key: const Key('openEditorButton'),
                context: context,
                icon: Icons.edit_outlined,
                label: appLocalizations.openEditor,
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
              // _buildActionButton(
              //   key: const Key('adjustButton'),
              //   context: context,
              //   icon: Icons.tune_rounded,
              //   label: appLocalizations.adjustButtonLabel,
              //   onTap: () async {
              //     if (imgLoader.image != null) {
              //       final canvasBytes =
              //           await Navigator.of(context).push<Uint8List>(
              //         MaterialPageRoute(
              //           builder: (context) => ProImageEditor.memory(
              //             img.encodeJpg(imgLoader.image!),
              //             callbacks: ProImageEditorCallbacks(
              //               onImageEditingComplete: (Uint8List bytes) async {
              //                 Navigator.pop(context, bytes);
              //               },
              //             ),
              //             configs: const ProImageEditorConfigs(
              //               paintEditor: PaintEditorConfigs(enabled: false),
              //               textEditor: TextEditorConfigs(enabled: false),
              //               cropRotateEditor: CropRotateEditorConfigs(
              //                 enabled: false,
              //               ),
              //               emojiEditor: EmojiEditorConfigs(enabled: false),
              //             ),
              //           ),
              //         ),
              //       );
              //       if (canvasBytes != null) {
              //         imgLoader.updateImage(
              //           bytes: canvasBytes,
              //           width: epd.width,
              //           height: epd.height,
              //         );
              //       }
              //     } else {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           duration: Durations.medium4,
              //           content: Text(appLocalizations.noImageSelectedFeedback),
              //           backgroundColor: colorPrimary,
              //         ),
              //       );
              //     }
              //   },
              // ),
              _buildActionButton(
                context: context,
                icon: Icons.photo_library_outlined,
                label: appLocalizations.library,
                onTap: () async {
                  await imageSaveHandler?.navigateToImageLibrary();
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.dashboard_customize_outlined,
                label: appLocalizations.templates,
                onTap: () async {
                  final result = await Navigator.of(context).push<Uint8List>(
                    MaterialPageRoute(
                      builder: (context) => CardTemplateSelectionView(
                        width: epd.width,
                        height: epd.height,
                      ),
                    ),
                  );

                  if (result != null) {
                    await imgLoader.updateImage(
                      bytes: result,
                      width: epd.width,
                      height: epd.height,
                    );
                    await imgLoader.saveFinalizedImageBytes(result);

                    onSourceChanged?.call('template');
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
    Key? key,
  }) {
    return Expanded(
      child: InkWell(
        key: key,
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: colorAccent, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: colorBlack,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
