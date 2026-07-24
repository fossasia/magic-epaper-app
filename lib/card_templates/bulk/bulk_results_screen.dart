import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/card_templates/bulk/bulk_result.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_document.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';
import 'package:provider/provider.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class BulkResultsScreen extends StatefulWidget {
  const BulkResultsScreen({
    super.key,
    required this.badges,
    required this.width,
    required this.height,
    this.device,
  });

  final List<GeneratedBadge> badges;
  final int width;
  final int height;
  final DisplayDevice? device;

  @override
  State<BulkResultsScreen> createState() => _BulkResultsScreenState();
}

class _BulkResultsScreenState extends State<BulkResultsScreen> {
  bool _savingAll = false;

  Map<String, dynamic> _metadataFor(GeneratedBadge badge) {
    return {
      if (widget.device != null) 'epdModel': widget.device!.modelId,
      if (badge.document != null) ...{
        'canvasDocument': badge.document!.toJson(),
        'sourceImage': base64Encode(badge.bytes),
      },
    };
  }

  Future<int> _persistAll() async {
    final provider = context.read<ImageLibraryProvider>();
    var saved = 0;
    for (final badge in widget.badges) {
      try {
        await provider.saveImage(
          name: badge.name,
          imageData: badge.bytes,
          source: 'bulk',
          metadata: _metadataFor(badge),
        );
        saved++;
      } catch (_) {}
    }
    return saved;
  }

  Future<void> _saveOne(GeneratedBadge badge) async {
    final provider = context.read<ImageLibraryProvider>();
    try {
      await provider.saveImage(
        name: badge.name,
        imageData: badge.bytes,
        source: 'bulk',
        metadata: _metadataFor(badge),
      );
      if (mounted) _snack(appLocalizations.bulkSavedCount(1));
    } catch (_) {
      if (mounted) _snack(appLocalizations.bulkSaveFailed);
    }
  }

  Future<void> _transfer(GeneratedBadge badge) async {
    final device = widget.device;
    if (device == null) return;
    final decoded = img.decodeImage(badge.bytes);
    if (decoded == null) return;
    await device.transfer(context, decoded);
  }

  Future<void> _edit(GeneratedBadge badge) async {
    final result = await Navigator.of(context).push<CanvasEditorResult>(
      MaterialPageRoute(
        builder: (context) => NativeCanvasEditor(
          width: widget.width,
          height: widget.height,
          initialLayers: badge.document == null ? badge.layers : null,
          initialDocument: badge.document,
          returnDocument: true,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        badge.bytes = result.png;
        badge.document = result.document;
      });
    }
  }

  Future<void> _saveAllAndDone() async {
    if (_savingAll) return;
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _savingAll = true);
    await _persistAll();
    if (!mounted) return;
    FocusManager.instance.primaryFocus?.unfocus();
    messenger.clearSnackBars();
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    _returnToEditor(nav);
  }

  void _returnToEditor(NavigatorState nav) {
    var sawTemplates = false;
    nav.popUntil((route) {
      if (sawTemplates || route.isFirst) return true;
      if (route.settings.name == 'cardTemplates') {
        sawTemplates = true;
        return false;
      }
      return false;
    });
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: -1,
      showBackButton: true,
      titleWidget: Text(
        appLocalizations.bulkResultsTitle,
        style: const TextStyle(
          fontSize: Dimens.fontSizeXxl,
          fontWeight: FontWeight.bold,
          color: colorWhite,
        ),
      ),
      body: SafeArea(
        top: false,
        child: widget.badges.isEmpty
            ? Center(child: Text(appLocalizations.bulkNothingGenerated))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Dimens.spacingL,
                        Dimens.spacingL, Dimens.spacingL, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: colorPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(Dimens.radiusM),
                          ),
                          child: const Icon(Icons.style_outlined,
                              size: 18, color: colorPrimary),
                        ),
                        const SizedBox(width: Dimens.spacingM),
                        Text(
                          appLocalizations
                              .bulkResultsCount(widget.badges.length),
                          style: const TextStyle(
                            fontSize: Dimens.fontSizeL,
                            fontWeight: FontWeight.bold,
                            color: colorBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(Dimens.spacingL),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        childAspectRatio: 0.82,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: widget.badges.length,
                      itemBuilder: (context, index) =>
                          _buildCard(widget.badges[index]),
                    ),
                  ),
                  _buildBottomBar(),
                ],
              ),
      ),
    );
  }

  Widget _buildCard(GeneratedBadge badge) {
    return Card(
      color: colorWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        side: BorderSide(color: grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.spacingM),
              child: AspectRatio(
                aspectRatio: widget.width / widget.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.radiusS),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: grey200)),
                    child: Image.memory(badge.bytes, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingS),
            child: Text(
              badge.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: colorBlack),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                tooltip: appLocalizations.bulkEdit,
                onPressed: () => _edit(badge),
                icon: const Icon(Icons.edit_outlined, color: colorPrimary),
              ),
              if (widget.device != null)
                IconButton(
                  tooltip: appLocalizations.bulkTransfer,
                  onPressed: () => _transfer(badge),
                  icon: const Icon(Icons.nfc, color: colorPrimary),
                ),
              IconButton(
                tooltip: appLocalizations.save,
                onPressed: () => _saveOne(badge),
                icon: const Icon(Icons.save_alt, color: colorAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacingL),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _savingAll ? null : _saveAllAndDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
                disabledBackgroundColor: grey300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusL),
                ),
              ),
              icon: _savingAll
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colorWhite),
                      ),
                    )
                  : const Icon(Icons.library_add),
              label: Text(
                appLocalizations.bulkSaveAllDone,
                style: const TextStyle(
                    fontSize: Dimens.fontSizeL, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
