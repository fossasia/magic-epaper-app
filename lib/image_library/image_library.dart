import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/image_library/services/image_operations_service.dart';
import 'package:magicepaperapp/image_library/widgets/app_bar_widget.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/batch_delete_confirmation_dialog.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/clear_all_confirmation_dialog.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:magicepaperapp/image_library/widgets/empty_state_widget.dart';
import 'package:magicepaperapp/image_library/widgets/image_grid_widget.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/image_preview_dialog.dart';
import 'package:magicepaperapp/image_library/widgets/search_and_filter_widget.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_document.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_element.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/provider/image_loader.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/view/image_editor.dart';
import 'package:provider/provider.dart';

class ImageLibraryScreen extends StatefulWidget {
  const ImageLibraryScreen({super.key});

  @override
  State<ImageLibraryScreen> createState() => _ImageLibraryScreenState();
}

class _ImageLibraryScreenState extends State<ImageLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isDeleteMode = false;
  final Set<String> _selectedImages = <String>{};
  late ImageOperationsService _operationsService;

  @override
  void initState() {
    super.initState();
    _operationsService = ImageOperationsService(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ImageLibraryProvider>().loadSavedImages();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleImageTap(SavedImage image) {
    if (_isDeleteMode) {
      _toggleImageSelection(image.id);
    } else {
      _showImagePreview(image);
    }
  }

  void _toggleImageSelection(String imageId) {
    setState(() {
      if (_selectedImages.contains(imageId)) {
        _selectedImages.remove(imageId);
      } else {
        _selectedImages.add(imageId);
      }
    });
  }

  void _showImagePreview(SavedImage image) {
    final provider = context.read<ImageLibraryProvider>();

    showDialog(
      context: context,
      builder: (context) => ImagePreviewDialog(
        image: image,
        epd: _operationsService.getEpdFromImage(image),
        onDelete: () => _showDeleteDialog(image, provider),
        onRename: (newName) =>
            _operationsService.renameImage(image, newName, provider),
        onTransfer: () => _operationsService.transferSingleImage(image),
        onEdit: () => _editImage(image),
      ),
    );
  }

  void _loadIntoImageEditor(
    DisplayDevice epd, {
    Map<String, dynamic>? pendingCanvasDocument,
    required String editingImageId,
    int? initialFilterIndex,
    bool initialFlipHorizontal = false,
    bool initialFlipVertical = false,
  }) {
    getIt<ColorPaletteProvider>().updateColors(epd.colors);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ImageEditor(
          device: epd,
          pendingCanvasDocument: pendingCanvasDocument,
          editingImageId: editingImageId,
          initialFilterIndex: initialFilterIndex,
          initialFlipHorizontal: initialFlipHorizontal,
          initialFlipVertical: initialFlipVertical,
        ),
      ),
    );
  }

  int? _savedFilterIndex(SavedImage image) {
    final raw = image.metadata?['filterIndex'];
    return raw is int ? raw : null;
  }

  bool _savedFlag(SavedImage image, String key) => image.metadata?[key] == true;

  Future<CanvasDocument?> _singleImageDocument(
      SavedImage image, DisplayDevice epd) async {
    final bytes = image.sourceImageBytes ?? await image.getImageData();
    if (bytes == null) return null;
    return CanvasDocument(
      width: epd.width,
      height: epd.height,
      canvasColor: Colors.white,
      elements: [
        CanvasElement(
          id: 'el_0',
          kind: CanvasElementKind.image,
          position: Offset(epd.width / 2, epd.height / 2),
          baseSize: Size(epd.width.toDouble(), epd.height.toDouble()),
          imageBytes: bytes,
        ),
      ],
      strokes: const [],
    );
  }

  Future<void> _editImage(SavedImage image) async {
    final epd = _operationsService.getEpdFromImage(image);
    final doc = image.canvasDocument ?? await _singleImageDocument(image, epd);
    if (doc == null || !mounted) return;
    final result = await Navigator.of(context).push<CanvasEditorResult>(
      MaterialPageRoute(
        builder: (_) => NativeCanvasEditor(
          width: doc.width,
          height: doc.height,
          returnDocument: true,
          initialDocument: doc,
        ),
      ),
    );
    if (result == null || !mounted) return;
    final imgLoader = context.read<ImageLoader>();
    await imgLoader.updateImage(
      bytes: result.png,
      width: epd.width,
      height: epd.height,
    );
    await imgLoader.saveFinalizedImageBytes(result.png);
    if (!mounted) return;
    _loadIntoImageEditor(
      epd,
      pendingCanvasDocument: result.document.toJson(),
      editingImageId: image.id,
      initialFilterIndex: _savedFilterIndex(image),
      initialFlipHorizontal: _savedFlag(image, 'flipHorizontal'),
      initialFlipVertical: _savedFlag(image, 'flipVertical'),
    );
  }

  void _showDeleteDialog(SavedImage image, ImageLibraryProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteConfirmationDialog(
        image: image,
        onConfirm: () => _operationsService.deleteImage(image, provider),
      ),
    );
  }

  void _showBatchDeleteDialog() {
    final provider = context.read<ImageLibraryProvider>();
    final selectedImageObjects = provider.savedImages
        .where((image) => _selectedImages.contains(image.id))
        .toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BatchDeleteConfirmationDialog(
        selectedImages: selectedImageObjects,
        onConfirm: () => _performBatchDelete(selectedImageObjects, provider),
      ),
    );
  }

  Future<void> _performBatchDelete(
    List<SavedImage> selectedImages,
    ImageLibraryProvider provider,
  ) async {
    await _operationsService.batchDeleteImages(selectedImages, provider);
    _exitDeleteMode();
  }

  void _exitDeleteMode() {
    setState(() {
      _isDeleteMode = false;
      _selectedImages.clear();
    });
  }

  void _enterDeleteMode() {
    setState(() {
      _isDeleteMode = true;
      _selectedImages.clear();
    });
  }

  void _showClearAllDialog() {
    final provider = context.read<ImageLibraryProvider>();
    final totalImages = provider.savedImages.length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ClearAllConfirmationDialog(
        totalImages: totalImages,
        onConfirm: () => _operationsService.clearAllData(provider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: LibraryAppBar(
        isDeleteMode: _isDeleteMode,
        selectedCount: _selectedImages.length,
        onDeletePressed: _showBatchDeleteDialog,
        onExitDeleteMode: _exitDeleteMode,
        onEnterDeleteMode: _enterDeleteMode,
        onClearAllPressed: _showClearAllDialog,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Consumer<ImageLibraryProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: colorAccent),
              );
            }

            if (provider.savedImages.isEmpty) {
              return const EmptyStateWidget();
            }

            return Column(
              children: [
                SearchAndFilterWidget(
                  searchController: _searchController,
                  provider: provider,
                ),
                Expanded(
                  child: ImageGridWidget(
                    images: provider.filteredImages,
                    isDeleteMode: _isDeleteMode,
                    selectedImages: _selectedImages,
                    onImageTap: _handleImageTap,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
