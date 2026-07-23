import 'dart:io';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/image_library/model/image_properties.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/image_library/services/image_operations_service.dart';
import 'package:magicepaperapp/image_library/utils/date_utils.dart' as dt;
import 'package:magicepaperapp/image_library/utils/filter_utils.dart';
import 'package:magicepaperapp/image_library/utils/source_utils.dart';
import 'package:magicepaperapp/image_library/widgets/image_error_placeholder.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import '../../../util/app_logger.dart';

class ImagePropertiesDialog extends StatefulWidget {
  final SavedImage image;

  const ImagePropertiesDialog({
    super.key,
    required this.image,
  });

  @override
  State<ImagePropertiesDialog> createState() => _ImagePropertiesDialogState();
}

class _ImagePropertiesDialogState extends State<ImagePropertiesDialog> {
  ImageProperties? _imageProperties;
  bool _isLoadingProperties = true;
  late ImageOperationsService _imageOperationsService;

  @override
  void initState() {
    super.initState();
    _imageOperationsService = ImageOperationsService(context);
    _loadImageProperties();
  }

  Future<void> _loadImageProperties() async {
    try {
      final properties =
          await _imageOperationsService.loadImageProperties(widget.image);
      if (!mounted) return;
      setState(() {
        _imageProperties = properties;
        _isLoadingProperties = false;
      });
    } catch (e) {
      AppLogger.error('Error in dialog loading image properties: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingProperties = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusXxl),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                child: _buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: const BoxDecoration(
        color: colorAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              color: colorWhite, size: Dimens.iconSizeL),
          const SizedBox(width: Dimens.spacingS),
          const Expanded(
            child: Text(
              'Image Properties',
              style: TextStyle(
                color: colorWhite,
                fontSize: Dimens.fontSizeXl,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: colorWhite),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: Dimens.spacingXl,
          left: Dimens.spacingXl,
          right: Dimens.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageThumbnail(),
          const SizedBox(height: Dimens.spacingMd),
          _buildSectionHeader('File Information'),
          const SizedBox(height: Dimens.spacingM),
          _buildFileInfoSection(),
          const SizedBox(height: Dimens.spacingMd),
          _buildSectionHeader('Image Properties'),
          const SizedBox(height: Dimens.spacingM),
          if (_isLoadingProperties)
            _buildLoadingSection()
          else if (_imageProperties != null)
            _buildImagePropertiesSection()
          else
            _buildErrorSection(),
          const SizedBox(height: Dimens.spacingXl),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail() {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: grey300),
          borderRadius: BorderRadius.circular(Dimens.radiusM),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          child: Image.file(
            File(widget.image.filePath),
            key: ValueKey(widget.image.imageCacheKey),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ImageErrorPlaceholder(iconSize: 40);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: Dimens.fontSizeL,
        fontWeight: FontWeight.bold,
        color: colorBlack87,
      ),
    );
  }

  Widget _buildFileInfoSection() {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: grey50,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(color: grey200),
      ),
      child: Column(
        children: [
          _buildPropertyRow('Name', widget.image.name),
          const Divider(height: 16),
          _buildPropertyRow(
              'Created', dt.DateUtils.formatFullDate(widget.image.createdAt)),
          const Divider(height: 16),
          _buildPropertyRow(
              'Source', SourceUtils.getSourceName(widget.image.source)),
          const Divider(height: 16),
          _buildPropertyRow('Filter Applied',
              FilterUtils.getFilterName(widget.image.metadata)),
        ],
      ),
    );
  }

  Widget _buildImagePropertiesSection() {
    final properties = _imageProperties!;

    return Container(
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildPropertyCard(Icons.photo_size_select_actual,
                      'Resolution', properties.resolution)),
              const SizedBox(width: Dimens.spacingM),
              Expanded(
                  child: _buildPropertyCard(Icons.storage, 'File Size',
                      properties.fileSizeFormatted)),
            ],
          ),
          const SizedBox(height: Dimens.spacingM),
          Row(
            children: [
              Expanded(
                  child: _buildPropertyCard(
                      Icons.image, 'Format', properties.format)),
              const SizedBox(width: Dimens.spacingM),
              Expanded(
                  child: _buildPropertyCard(
                      Icons.camera, 'Megapixels', properties.megapixels)),
            ],
          ),
          const SizedBox(height: Dimens.spacingM),
          Row(
            children: [
              Expanded(
                  child: _buildPropertyCard(Icons.aspect_ratio, 'Aspect Ratio',
                      '${properties.aspectRatio.toStringAsFixed(2)}:1')),
              const SizedBox(width: Dimens.spacingM),
              Expanded(
                  child: _buildPropertyCard(Icons.straighten, 'Dimensions',
                      '${properties.width} × ${properties.height}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingM),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(Dimens.radiusS),
        border: Border.all(color: grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: Dimens.iconSizeS, color: colorAccent),
              const SizedBox(width: Dimens.spacingSm),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacingXs),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colorBlack87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: grey700,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: Dimens.spacingM),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: colorBlack87,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingXxl),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: Dimens.spacingM),
            Text(appLocalizations.loadingImageProperties),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: Dimens.spacingS),
          const Expanded(
            child: Text(
              'Unable to load image properties',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
