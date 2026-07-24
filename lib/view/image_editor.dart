import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/image_library/services/image_save_handler.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_document.dart';
import 'package:magicepaperapp/card_templates/card_template_selection_view.dart';
import 'package:magicepaperapp/util/color_util.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/xbm_encoder.dart';
import 'package:magicepaperapp/view/text_fit_editor.dart';
import 'package:magicepaperapp/view/widget/image_list.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:magicepaperapp/util/page_route_util.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/provider/image_loader.dart';
import 'package:magicepaperapp/util/epd/epd.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import '../src/rust/api/simple.dart' as rust_api;
import '../util/app_logger.dart';

class ImageEditor extends StatefulWidget {
  final DisplayDevice device;
  final bool isExportOnly;

  final Map<String, dynamic>? pendingCanvasDocument;
  final String? editingImageId;

  final int? initialFilterIndex;
  final bool initialFlipHorizontal;
  final bool initialFlipVertical;

  const ImageEditor({
    super.key,
    required this.device,
    this.isExportOnly = false,
    this.pendingCanvasDocument,
    this.editingImageId,
    this.initialFilterIndex,
    this.initialFlipHorizontal = false,
    this.initialFlipVertical = false,
  });

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
  List<Uint8List> _processedPngs = [];
  ImageSaveHandler? _imageSaveHandler;
  bool _isProcessingImages = false;
  bool _isInitializing = true;

  Map<String, dynamic>? _pendingCanvasDocument;
  String? _editingLibraryImageId;
  int? _pendingInitialFilterIndex;
  bool _pendingInitialFlipH = false;
  bool _pendingInitialFlipV = false;
  bool _hasPendingInitialState = false;

  @override
  void initState() {
    AppLogger.info('DEBUG: ImageEditor initState called');
    setPortraitOrientation();
    super.initState();
    _selectedWaveform = null;
    _selectedWaveformName = null;
    _pendingCanvasDocument = widget.pendingCanvasDocument;
    _editingLibraryImageId = widget.editingImageId;
    _pendingInitialFilterIndex = widget.initialFilterIndex;
    _pendingInitialFlipH = widget.initialFlipHorizontal;
    _pendingInitialFlipV = widget.initialFlipVertical;
    _hasPendingInitialState = widget.editingImageId != null;
    if (widget.editingImageId != null) _currentImageSource = 'editor';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isInitializing = false;
      });
      loadInitialImage();
    });
  }

  Future<void> loadInitialImage() async {
    try {
      final imgLoader = context.read<ImageLoader>();
      if (imgLoader.image == null) {
        await imgLoader.loadFinalizedImage(
          width: widget.device.width,
          height: widget.device.height,
        );
      }
      if (imgLoader.image == null) {
        await loadDefaultImage(imgLoader);
      }
    } catch (e) {
      AppLogger.error('Error loading initial image: $e');
    }
  }

  Future<void> loadDefaultImage(ImageLoader imgLoader) async {
    try {
      final byteData = await rootBundle.load(ImageAssets.fossasiaDefault);
      final pngBytes = byteData.buffer.asUint8List();
      await imgLoader.updateImage(
        bytes: pngBytes,
        width: widget.device.width,
        height: widget.device.height,
      );
    } catch (e) {
      AppLogger.error('Error loading default image: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageSaveHandler = ImageSaveHandler(
      context: context,
      provider: context.read<ImageLibraryProvider>(),
    );
  }

  void _saveCurrentImage() async {
    if (_imageSaveHandler == null) return;

    Uint8List? sourceBytes;
    final src = _processedSourceImage;
    if (src != null) {
      final resized = img.copyResize(
        src,
        width: widget.device.width,
        height: widget.device.height,
      );
      sourceBytes = Uint8List.fromList(img.encodePng(resized));
    }

    await _imageSaveHandler!.saveCurrentImage(
      rawImages: _rawImages,
      selectedFilterIndex: _selectedFilterIndex,
      flipHorizontal: flipHorizontal,
      flipVertical: flipVertical,
      currentImageSource: _currentImageSource,
      processingMethods: widget.device.processingMethods,
      modelId: widget.device.modelId,
      deviceWidth: widget.device.width,
      deviceHeight: widget.device.height,
      deviceColors: widget.device.colors,
      canvasDocument: _pendingCanvasDocument,
      sourceImage: sourceBytes,
      existingImageId: _editingLibraryImageId,
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
          _processedPngs = [];
          _isProcessingImages = false;
        });
      }
      return;
    }

    if (_processedSourceImage == sourceImage) {
      return;
    }

    _processImagesAsync(sourceImage);
  }

  Future<void> _processImagesAsync(img.Image sourceImage) async {
    if (_isProcessingImages) return;

    setState(() {
      _isProcessingImages = true;
      _rawImages = [];
      _processedPngs = [];
      _processedSourceImage = sourceImage;
      _selectedFilterIndex = 0;
      flipHorizontal = false;
      flipVertical = false;
    });

    final Uint8List sourcePngBytes =
        Uint8List.fromList(img.encodePng(sourceImage));
    final filtersToRun = widget.device.processingMethods;

    try {
      for (int i = 0; i < filtersToRun.length; i++) {
        if (!mounted || _processedSourceImage != sourceImage) break;

        Uint8List bytesForRust = sourcePngBytes;

        if (filtersToRun[i].useDartHalftone) {
          final tempImg = img.Image.from(sourceImage);
          if (!filtersToRun[i].isBwr) {
            img.grayscale(tempImg);
          }
          img.colorHalftone(tempImg, size: 3);
          bytesForRust = Uint8List.fromList(img.encodePng(tempImg));
        }

        final Uint8List processedPngBytes = await rust_api.processImageRust(
          imageBytes: bytesForRust,
          targetWidth: widget.device.width.toInt(),
          targetHeight: widget.device.height.toInt(),
          method: filtersToRun[i].method,
          isBwr: filtersToRun[i].isBwr,
        );

        final img.Image? decodedImage =
            await compute(img.decodePng, processedPngBytes);

        if (mounted && _processedSourceImage == sourceImage) {
          setState(() {
            _processedPngs.add(processedPngBytes);
            _rawImages.add(decodedImage!);
            if (i == 0) {
              _isProcessingImages = false;
            }
          });
        }
      }
    } catch (e) {
      AppLogger.error('Exception in Rust processing: $e');
      if (mounted) setState(() => _isProcessingImages = false);
    }
    _applyPendingInitialState(sourceImage);
  }

  void _applyPendingInitialState(img.Image sourceImage) {
    if (!_hasPendingInitialState) return;
    _hasPendingInitialState = false;
    if (!mounted || _processedSourceImage != sourceImage) return;
    final idx = _pendingInitialFilterIndex;
    setState(() {
      if (idx != null && idx > 0 && idx < _processedPngs.length) {
        _selectedFilterIndex = idx;
      }
      flipHorizontal = _pendingInitialFlipH;
      flipVertical = _pendingInitialFlipV;
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

      final nonWhiteColors = widget.device.colors.where((c) => c != colorWhite);

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
              appLocalizations.xbmFilesExportedSuccessfully(exportedCount)),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(
          content: Text(appLocalizations.exportFailedMessage(e.toString()))));
    }
  }

  String _localizedWaveformName(
      String name, AppLocalizations appLocalizations) {
    switch (name) {
      case 'Quick Refresh':
        return appLocalizations.quickRefresh;
      default:
        return name;
    }
  }

  Widget _buildWaveformDropdownGroup(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final epd = widget.device as Epd;
    const double controlHeight = 32.0;
    const TextStyle itemTextStyle = TextStyle(
      color: colorWhite,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    final List<DropdownMenuItem<String?>> dropdownItems = [
      DropdownMenuItem<String?>(
        value: null,
        child: Text(appLocalizations.fullRefresh, style: itemTextStyle),
      ),
      ...epd.controller.waveforms.map((waveform) {
        return DropdownMenuItem<String?>(
          value: waveform.name,
          child: Text(
            _localizedWaveformName(waveform.name, appLocalizations),
            style: itemTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onLongPress: () => _showRefreshModeInfoDialog(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130, minWidth: 92),
            child: Container(
              height: controlHeight,
              decoration: BoxDecoration(
                color: colorAccent,
                border: Border.all(
                    color: colorWhite, width: Dimens.borderWidthThin),
                borderRadius: BorderRadius.circular(Dimens.radiusM),
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingS),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _selectedWaveformName,
                  isExpanded: true,
                  isDense: true,
                  hint: Text(
                    appLocalizations.fullRefresh,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: itemTextStyle,
                  ),
                  dropdownColor: colorAccent,
                  style: itemTextStyle,
                  borderRadius: BorderRadius.circular(Dimens.radiusM),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: colorWhite, size: 18),
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
                        duration: const Duration(milliseconds: 1200),
                        content: Text(
                          appLocalizations.waveformSelectedMessage(
                            _selectedWaveform != null
                                ? _localizedWaveformName(
                                    _selectedWaveform!.name, appLocalizations)
                                : appLocalizations.fullRefresh,
                          ),
                        ),
                        backgroundColor: colorPrimary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: Dimens.spacingXxs),
        InkWell(
          onTap: () => _showRefreshModeInfoDialog(context),
          customBorder: const CircleBorder(),
          // Compact 32 footprint so the title keeps its horizontal space
          // on narrow screens (a 48 box squeezed the title too much).
          child: const SizedBox(
            height: controlHeight,
            width: controlHeight,
            child: Icon(Icons.info_outline,
                color: colorWhite, size: Dimens.iconSizeM),
          ),
        ),
      ],
    );
  }

  Widget _buildTransferActionButton(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return TextButton(
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
        foregroundColor: colorWhite,
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingM, vertical: Dimens.spacingXs),
        // Visual height stays compact (32), but the default padded
        // tapTargetSize keeps the touch target at the 48dp guideline.
        minimumSize: const Size(0, 32),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          side: const BorderSide(
              color: colorWhite, width: Dimens.borderWidthThin),
        ),
      ),
      child: Text(
        widget.isExportOnly
            ? appLocalizations.exportXbm
            : appLocalizations.transferButtonLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _showRefreshModeInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            appLocalizations.refreshModeInfo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimens.fontSizeXl,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appLocalizations.fullRefreshInfo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimens.fontSizeL,
                    color: colorAccent,
                  ),
                ),
                const SizedBox(height: Dimens.spacingS),
                Text(
                  appLocalizations.fullRefreshDescription,
                  style: const TextStyle(fontSize: Dimens.fontSizeM),
                ),
                const SizedBox(height: Dimens.spacingL),
                Text(
                  appLocalizations.partialRefreshInfo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimens.fontSizeL,
                    color: colorAccent,
                  ),
                ),
                const SizedBox(height: Dimens.spacingS),
                Text(
                  appLocalizations.partialRefreshDescription,
                  style: const TextStyle(fontSize: Dimens.fontSizeM),
                ),
                const SizedBox(height: Dimens.spacingL),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: colorAccent,
              ),
              child: Text(appLocalizations.ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    var imgLoader = context.watch<ImageLoader>();
    if (!_isInitializing && imgLoader.image != null && !_isProcessingImages) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateProcessedImages(imgLoader.image);
      });
    }

    final bool hasActions = _rawImages.isNotEmpty;
    final bool hasDropdown =
        hasActions && widget.device is Epd && !widget.isExportOnly;

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: colorWhite),
        titleSpacing: 0.0,
        backgroundColor: colorAccent,
        elevation: 0,
        title: Text(
          appLocalizations.filterScreenTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: colorWhite,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        actions: hasActions
            ? [
                if (hasDropdown)
                  Padding(
                    padding: const EdgeInsets.only(right: Dimens.spacingSm),
                    child:
                        _buildWaveformDropdownGroup(context, appLocalizations),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: Dimens.spacingS),
                  child: _buildTransferActionButton(context, appLocalizations),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: _isInitializing || imgLoader.isLoading || _isProcessingImages
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(colorAccent),
                    ),
                    const SizedBox(height: Dimens.spacingL),
                    Text(
                      _isProcessingImages
                          ? appLocalizations.processingImages
                          : appLocalizations.loading,
                      style: const TextStyle(
                          color: colorBlack, fontSize: Dimens.fontSizeM),
                    ),
                  ],
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.spacingS),
                child: _processedPngs.isNotEmpty
                    ? ImageList(
                        key: ValueKey(_processedSourceImage),
                        processedPngs: _processedPngs,
                        epd: widget.device,
                        width: widget.device.height,
                        height: widget.device.width,
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
                          style: const TextStyle(
                              color: grey500, fontSize: Dimens.fontSizeL),
                        ),
                      ),
              ),
      ),
      bottomNavigationBar: BottomActionMenu(
          epd: widget.device,
          imgLoader: imgLoader,
          imageSaveHandler: _imageSaveHandler,
          onCanvasDocument: (doc) {
            setState(() {
              _pendingCanvasDocument = doc;
            });
          },
          onSourceChanged: (String source) {
            setState(() {
              _currentImageSource = source;
              if (source != 'editor') {
                _pendingCanvasDocument = null;
              }
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
  final Function(Map<String, dynamic>)? onCanvasDocument;

  const BottomActionMenu({
    super.key,
    required this.epd,
    required this.imgLoader,
    required this.imageSaveHandler,
    this.onSourceChanged,
    this.onCanvasDocument,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final MediaQueryData mq = MediaQuery.of(context);
    final double screenWidth = mq.size.width;
    final double textScale = mq.textScaler.scale(1.0);
    final bool isNarrow = screenWidth < 360;
    final double iconSize = isNarrow ? 20.0 : 22.0;
    final double fontSize = isNarrow ? 9.0 : 10.0;
    // Grow the bar height with the user's font-scale so labels don't clip
    // vertically under accessibility settings.
    final double barHeight = 75.0 + ((textScale - 1.0).clamp(0.0, 0.6)) * 28.0;
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        height: barHeight,
        decoration: BoxDecoration(
          color: colorWhite,
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
          padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? Dimens.spacingXs : Dimens.spacingS,
              vertical: Dimens.spacingSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context: context,
                icon: Icons.add_photo_alternate_outlined,
                iconSize: iconSize,
                fontSize: fontSize,
                label: appLocalizations.import,
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
                iconSize: iconSize,
                fontSize: fontSize,
                label: appLocalizations.openEditor,
                onTap: () async {
                  final result =
                      await Navigator.of(context).push<CanvasEditorResult>(
                    buildOpaqueSlideRoute(
                      NativeCanvasEditor(
                        width: epd.width,
                        height: epd.height,
                        returnDocument: true,
                      ),
                    ),
                  );
                  if (result == null) return;
                  await imgLoader.updateImage(
                    bytes: result.png,
                    width: epd.width,
                    height: epd.height,
                  );
                  await imgLoader.saveFinalizedImageBytes(result.png);
                  onCanvasDocument?.call(result.document.toJson());
                  onSourceChanged?.call('editor');
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.text_fields,
                iconSize: iconSize,
                fontSize: fontSize,
                label: appLocalizations.text,
                onTap: () async {
                  final bytes = await Navigator.of(context).push<Uint8List>(
                    MaterialPageRoute(
                      builder: (context) => TextFitEditor(
                        width: epd.width,
                        height: epd.height,
                      ),
                    ),
                  );
                  if (bytes != null) {
                    await imgLoader.updateImage(
                      bytes: bytes,
                      width: epd.width,
                      height: epd.height,
                    );
                    await imgLoader.saveFinalizedImageBytes(bytes);
                    onSourceChanged?.call('text');
                  }
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.photo_library_outlined,
                iconSize: iconSize,
                fontSize: fontSize,
                label: appLocalizations.library,
                onTap: () async {
                  await imageSaveHandler?.navigateToImageLibrary();
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.dashboard_customize_outlined,
                iconSize: iconSize,
                fontSize: fontSize,
                label: appLocalizations.templates,
                onTap: () async {
                  final result = await Navigator.of(context).push<Uint8List>(
                    MaterialPageRoute(
                      settings: const RouteSettings(name: 'cardTemplates'),
                      builder: (context) => CardTemplateSelectionView(
                        width: epd.width,
                        height: epd.height,
                        device: epd,
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
    required double iconSize,
    required double fontSize,
    Key? key,
  }) {
    return Expanded(
      child: InkWell(
        key: key,
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.radiusXxl),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingXxs, vertical: Dimens.spacingXs),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: colorAccent, size: iconSize),
              const SizedBox(height: Dimens.spacingXxs),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: colorBlack,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
