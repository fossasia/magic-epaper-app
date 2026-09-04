import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/epd/brand.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/gdeq031t10.dart';
import 'package:magicepaperapp/util/epd/gdey029f51.dart';
import 'package:magicepaperapp/util/epd/gdey037z03.dart';
import 'package:magicepaperapp/util/epd/gdey037z03bw.dart';
import 'package:magicepaperapp/util/epd/waveshare_displays.dart';
import 'package:magicepaperapp/view/image_editor.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';
import 'package:magicepaperapp/view/widget/display_card.dart';
import 'package:provider/provider.dart';
import 'package:magicepaperapp/theme/colors.dart';

enum ColorFilter { bw, bwr, bwry }

extension ColorFilterLabel on ColorFilter {
  String label(AppLocalizations l) {
    switch (this) {
      case ColorFilter.bw:
        return l.colorBw;
      case ColorFilter.bwr:
        return l.colorBwr;
      case ColorFilter.bwry:
        return l.colorBwry;
    }
  }

  bool matches(DisplayDevice d) {
    switch (this) {
      case ColorFilter.bw:
        return d.colors.length <= 2;
      case ColorFilter.bwr:
        return d.colors.length == 3;
      case ColorFilter.bwry:
        return d.colors.length >= 4;
    }
  }
}

class DisplaySelectionScreen extends StatefulWidget {
  const DisplaySelectionScreen({super.key});

  @override
  State<DisplaySelectionScreen> createState() => _DisplaySelectionScreenState();
}

class _DisplaySelectionScreenState extends State<DisplaySelectionScreen> {
  final List<DisplayDevice> displays = [
    GDEQ031T10(),
    Gdey037z03BW(),
    Gdey037z03(),
    GDEY029F51(),
    Waveshare2in13(),
    Waveshare2in9(),
    Waveshare2in9b(),
    Waveshare2in7(),
    Waveshare4in2(),
    Waveshare7in5(),
    Waveshare7in5HD(),
  ];

  final ScrollController _scrollController = ScrollController();

  Set<Brand> _selectedBrands = {};
  Set<ColorFilter> _selectedColorFilters = {};
  Set<String> _selectedSizes = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String? _sizeOf(DisplayDevice d) {
    final match = RegExp(r'(\d+(\.\d+)?)"').firstMatch(d.name);
    return match?.group(0);
  }

  List<String> get _availableSizes {
    final sizes = displays.map(_sizeOf).whereType<String>().toSet().toList();
    sizes.sort((a, b) {
      final da = double.tryParse(a.replaceAll('"', '')) ?? 0;
      final db = double.tryParse(b.replaceAll('"', '')) ?? 0;
      return da.compareTo(db);
    });
    return sizes;
  }

  List<DisplayDevice> get _filteredDisplays {
    return displays.where((d) {
      final brandOk =
          _selectedBrands.isEmpty || _selectedBrands.contains(d.brand);
      final colorOk = _selectedColorFilters.isEmpty ||
          _selectedColorFilters.any((c) => c.matches(d));
      final sizeOk =
          _selectedSizes.isEmpty || _selectedSizes.contains(_sizeOf(d));
      return brandOk && colorOk && sizeOk;
    }).toList();
  }

  Map<Brand, List<DisplayDevice>> get _groupedByBrand {
    final map = <Brand, List<DisplayDevice>>{};
    for (final d in _filteredDisplays) {
      map.putIfAbsent(d.brand, () => []).add(d);
    }
    return map;
  }

  void _onTap(BuildContext context, DisplayDevice display) {
    context.read<ColorPaletteProvider>().updateColors(display.colors);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _LoadingWrapper(
          child: ImageEditor(isExportOnly: false, device: display),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Future<void> _showFilterSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) labelOf,
    required Set<T> selected,
    required void Function(Set<T>) onApply,
  }) async {
    final tempSelected = Set<T>.from(selected);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingM, vertical: Dimens.spacingS),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: Dimens.fontSizeL,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() => tempSelected.clear());
                          },
                          child: Text(AppLocalizations.of(context)!.clear),
                        ),
                      ],
                    ),
                    const Divider(),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: items.map((item) {
                          final isSelected = tempSelected.contains(item);
                          return CheckboxListTile(
                            activeColor: colorPrimary,
                            value: isSelected,
                            title: Text(labelOf(item)),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (val) {
                              setModalState(() {
                                if (val == true) {
                                  tempSelected.add(item);
                                } else {
                                  tempSelected.remove(item);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: Dimens.spacingS),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: colorAccent),
                        onPressed: () {
                          onApply(tempSelected);
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.apply),
                      ),
                    ),
                    const SizedBox(height: Dimens.spacingS),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterBox({
    required String allLabel,
    required int selectedCount,
    required VoidCallback onTap,
  }) {
    final hasSelection = selectedCount > 0;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingS, vertical: Dimens.spacingSm),
          decoration: BoxDecoration(
            color:
                hasSelection ? colorAccent.withValues(alpha: .1) : colorWhite,
            border: Border.all(
              color: hasSelection ? colorAccent : mdGrey400,
              width: hasSelection ? 1.5 : Dimens.borderWidthThin,
            ),
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  hasSelection
                      ? AppLocalizations.of(context)!
                          .selectedCount(selectedCount)
                      : allLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Dimens.fontSizeS,
                    fontWeight: FontWeight.w600,
                    color: hasSelection ? colorAccent : colorBlack,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down,
                  size: 18, color: hasSelection ? colorAccent : mdGrey400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingMd, vertical: Dimens.spacingS),
      child: Row(
        children: [
          _buildFilterBox(
            allLabel: l.allBrands,
            selectedCount: _selectedBrands.length,
            onTap: () => _showFilterSheet<Brand>(
              context: context,
              title: l.brand,
              items: Brand.values,
              labelOf: (b) => b.label(l),
              selected: _selectedBrands,
              onApply: (result) => setState(() => _selectedBrands = result),
            ),
          ),
          const SizedBox(width: Dimens.spacingS),
          _buildFilterBox(
            allLabel: l.allColors,
            selectedCount: _selectedColorFilters.length,
            onTap: () => _showFilterSheet<ColorFilter>(
              context: context,
              title: l.colors,
              items: ColorFilter.values,
              labelOf: (c) => c.label(l),
              selected: _selectedColorFilters,
              onApply: (result) =>
                  setState(() => _selectedColorFilters = result),
            ),
          ),
          const SizedBox(width: Dimens.spacingS),
          _buildFilterBox(
            allLabel: l.allSizes,
            selectedCount: _selectedSizes.length,
            onTap: () => _showFilterSheet<String>(
              context: context,
              title: l.size,
              items: _availableSizes,
              labelOf: (s) => s,
              selected: _selectedSizes,
              onApply: (result) => setState(() => _selectedSizes = result),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandHeader(Brand brand, AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimens.spacingMd, Dimens.spacingM, Dimens.spacingMd, Dimens.spacingS),
      child: Text(
        brand.label(l),
        style: const TextStyle(
          fontSize: Dimens.fontSizeL,
          fontWeight: FontWeight.bold,
          color: colorAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final grouped = _groupedByBrand;

    return ChangeNotifierProvider<ColorPaletteProvider>.value(
      value: getIt<ColorPaletteProvider>(),
      builder: (context, child) {
        return CommonScaffold(
          index: 0,
          toolbarHeight: 70,
          leadingUpOffset: 12,
          titleWidget: Builder(
            builder: (context) {
              final double windowWidth = MediaQuery.of(context).size.width;
              final bool showTitle = windowWidth >= 200;
              final bool showSubtitle = windowWidth >= 340;
              if (!showTitle) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(left: 5, right: Dimens.spacingL),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations.appName,
                        style: const TextStyle(
                          fontSize: Dimens.fontSizeDisplay,
                          fontWeight: FontWeight.bold,
                          color: colorWhite,
                        ),
                      ),
                      if (showSubtitle) ...[
                        const SizedBox(height: Dimens.spacingS),
                        Text(
                          appLocalizations.selectDisplayType,
                          style: const TextStyle(
                            fontSize: Dimens.fontSizeL,
                            color: colorWhite,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: Column(
              children: [
                _buildFilterBar(appLocalizations),
                const Divider(height: 1),
                Expanded(
                  child: grouped.isEmpty
                      ? Center(
                          child: Text(
                            appLocalizations.noResultsFound,
                            style: const TextStyle(
                                color: mdGrey400, fontSize: Dimens.fontSizeL),
                          ),
                        )
                      : Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              for (final entry in grouped.entries) ...[
                                SliverToBoxAdapter(
                                  child: _buildBrandHeader(
                                      entry.key, appLocalizations),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.spacingMd,
                                  ),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 340,
                                      mainAxisSpacing: Dimens.spacingS,
                                      crossAxisSpacing: Dimens.spacingS,
                                      childAspectRatio: 0.75,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final display = entry.value[index];
                                        return DisplayCard.fill(
                                          key: Key(display.modelId),
                                          display: display,
                                          isSelected: false,
                                          onTap: () => _onTap(context, display),
                                        );
                                      },
                                      childCount: entry.value.length,
                                    ),
                                  ),
                                ),
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: Dimens.spacingS),
                                ),
                              ],
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoadingWrapper extends StatefulWidget {
  final Widget child;
  const _LoadingWrapper({required this.child});

  @override
  State<_LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<_LoadingWrapper> {
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() => _showLoading = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoading) {
      return Scaffold(
        backgroundColor: colorWhite,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
              ),
              const SizedBox(height: Dimens.spacingL),
              Text(
                AppLocalizations.of(context)!.loading,
                style: const TextStyle(
                    color: colorBlack, fontSize: Dimens.fontSizeM),
              ),
            ],
          ),
        ),
      );
    }
    return widget.child;
  }
}
