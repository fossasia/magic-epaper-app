import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/utils/epd/brand.dart';
import 'package:magicepaperapp/utils/epd/display_device.dart';
import 'package:magicepaperapp/utils/epd/gdeq031t10.dart';
import 'package:magicepaperapp/utils/epd/gdey037z03.dart';
import 'package:magicepaperapp/utils/epd/gdey037z03bw.dart';
import 'package:magicepaperapp/utils/epd/goodisplay_2color.dart';
import 'package:magicepaperapp/utils/epd/goodisplay_3color.dart';
import 'package:magicepaperapp/utils/epd/goodisplay_4color.dart';
import 'package:magicepaperapp/utils/epd/waveshare_displays.dart';
import 'package:magicepaperapp/view/image_editor.dart';
import 'package:magicepaperapp/view/widgets/common_scaffold_widget.dart';
import 'package:magicepaperapp/view/widgets/display_card.dart';
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

enum SortOption {
  defaultOrder,
  nameAsc,
  nameDesc,
  sizeAsc,
  sizeDesc,
  colorCountAsc,
  colorCountDesc,
}

extension SortOptionLabel on SortOption {
  String label(AppLocalizations l) {
    switch (this) {
      case SortOption.defaultOrder:
        return l.sortDefault;
      case SortOption.nameAsc:
        return l.sortNameAsc;
      case SortOption.nameDesc:
        return l.sortNameDesc;
      case SortOption.sizeAsc:
        return l.sortSizeAsc;
      case SortOption.sizeDesc:
        return l.sortSizeDesc;
      case SortOption.colorCountAsc:
        return l.sortColorCountAsc;
      case SortOption.colorCountDesc:
        return l.sortColorCountDesc;
    }
  }
}

enum _FilterCategory { sort, brand, color, size, beta }

class _FilterResult {
  final SortOption sortOption;
  final Set<Brand> selectedBrands;
  final Set<ColorFilter> selectedColorFilters;
  final Set<String> selectedSizes;
  final bool showBeta;

  const _FilterResult({
    required this.sortOption,
    required this.selectedBrands,
    required this.selectedColorFilters,
    required this.selectedSizes,
    required this.showBeta,
  });
}

class DisplaySelectionScreen extends StatefulWidget {
  const DisplaySelectionScreen({super.key});

  @override
  State<DisplaySelectionScreen> createState() => _DisplaySelectionScreenState();
}

class _DisplaySelectionScreenState extends State<DisplaySelectionScreen> {
  final List<DisplayDevice> displays = [
    GDEY0154D67(),
    GDEY0213B74(),
    GDEY029T94(),
    GDEY042T81(),
    GDEW0154T8D(),
    GDEW0213T5D(),
    GDEW029T5D(),
    GDEW042T2(),
    GDEY037T03(),
    GDEY0154Z90(),
    GDEY0213Z98(),
    GDEY029Z95(),
    GDEY042Z98(),
    GDEW0213Z16(),
    GDEW029Z13(),
    GDEQ042Z21(),
    GDEY037Z03(),
    GDEY029F51(),
    GDEY029F51H(),
    GDEY0213F52(),
    GDEY0266F51(),
    GDEY0266F51H(),
    GDEM0097F51(),
    GDEM0154F51H(),
    GDEM037F52(),
    GDEM042F52(),
    GDEQ031T10(),
    Gdey037z03BW(),
    Gdey037z03(),
    GDEY029F51(),
    Waveshare1in54(),
    Waveshare1in54g(),
    Waveshare2in13(),
    Waveshare2in13g(),
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
  SortOption _sortOption = SortOption.sizeAsc;
  bool _showBeta = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters =>
      _selectedBrands.isNotEmpty ||
      _selectedColorFilters.isNotEmpty ||
      _selectedSizes.isNotEmpty ||
      _sortOption != SortOption.sizeAsc ||
      _showBeta;

  double _sizeValue(DisplayDevice d) {
    final match = RegExp(r'(\d+(\.\d+)?)"').firstMatch(d.name);
    if (match == null) {
      return 0;
    }
    return double.tryParse(match.group(1)!) ?? 0;
  }

  int Function(DisplayDevice, DisplayDevice) _comparatorFor(SortOption option) {
    switch (option) {
      case SortOption.defaultOrder:
        return (a, b) => _sizeValue(a).compareTo(_sizeValue(b));
      case SortOption.nameAsc:
        return (a, b) => a.name.compareTo(b.name);
      case SortOption.nameDesc:
        return (a, b) => b.name.compareTo(a.name);
      case SortOption.sizeAsc:
        return (a, b) => _sizeValue(a).compareTo(_sizeValue(b));
      case SortOption.sizeDesc:
        return (a, b) => _sizeValue(b).compareTo(_sizeValue(a));
      case SortOption.colorCountAsc:
        return (a, b) => a.colors.length.compareTo(b.colors.length);
      case SortOption.colorCountDesc:
        return (a, b) => b.colors.length.compareTo(a.colors.length);
    }
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

  List<DisplayDevice> get _sortedFilteredDisplays {
    final filtered = displays.where((d) {
      final brandOk =
          _selectedBrands.isEmpty || _selectedBrands.contains(d.brand);
      final colorOk = _selectedColorFilters.isEmpty ||
          _selectedColorFilters.any((c) => c.matches(d));
      final sizeOk =
          _selectedSizes.isEmpty || _selectedSizes.contains(_sizeOf(d));
      final betaOk = _showBeta || !d.isBeta;
      return brandOk && colorOk && sizeOk && betaOk;
    }).toList();
    filtered.sort(_comparatorFor(_sortOption));
    return filtered;
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

  Future<void> _showFilterPanel() async {
    final result = await Navigator.push<_FilterResult>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _FilterScreen(
          sortOption: _sortOption,
          selectedBrands: _selectedBrands,
          selectedColorFilters: _selectedColorFilters,
          selectedSizes: _selectedSizes,
          showBeta: _showBeta,
          availableSizes: _availableSizes,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _sortOption = result.sortOption;
        _selectedBrands = result.selectedBrands;
        _selectedColorFilters = result.selectedColorFilters;
        _selectedSizes = result.selectedSizes;
        _showBeta = result.showBeta;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final sortedDisplays = _sortedFilteredDisplays;

    return ChangeNotifierProvider<ColorPaletteProvider>.value(
      value: getIt<ColorPaletteProvider>(),
      builder: (context, child) {
        return CommonScaffold(
          index: 0,
          toolbarHeight: 70,
          leadingUpOffset: 12,
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.tune, color: colorWhite),
                  tooltip: appLocalizations.filters,
                  onPressed: _showFilterPanel,
                ),
                if (_hasActiveFilters)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          titleWidget: Builder(
            builder: (context) {
              final double windowWidth = MediaQuery.of(context).size.width;
              final bool showTitle = windowWidth >= 200;
              final bool showSubtitle = windowWidth >= 340;
              if (!showTitle) {
                return const SizedBox.shrink();
              }
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
                Expanded(
                  child: sortedDisplays.isEmpty
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
                              SliverPadding(
                                padding:
                                    const EdgeInsets.all(Dimens.spacingMd),
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
                                      final display = sortedDisplays[index];
                                      return DisplayCard.fill(
                                        key: Key(display.modelId),
                                        display: display,
                                        isSelected: false,
                                        onTap: () =>
                                            _onTap(context, display),
                                      );
                                    },
                                    childCount: sortedDisplays.length,
                                  ),
                                ),
                              ),
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

class _FilterScreen extends StatefulWidget {
  final SortOption sortOption;
  final Set<Brand> selectedBrands;
  final Set<ColorFilter> selectedColorFilters;
  final Set<String> selectedSizes;
  final bool showBeta;
  final List<String> availableSizes;

  const _FilterScreen({
    required this.sortOption,
    required this.selectedBrands,
    required this.selectedColorFilters,
    required this.selectedSizes,
    required this.showBeta,
    required this.availableSizes,
  });

  @override
  State<_FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<_FilterScreen> {
  late SortOption _sortOption;
  late Set<Brand> _selectedBrands;
  late Set<ColorFilter> _selectedColorFilters;
  late Set<String> _selectedSizes;
  late bool _showBeta;
  _FilterCategory _activeCategory = _FilterCategory.sort;

  @override
  void initState() {
    super.initState();
    _sortOption = widget.sortOption;
    _selectedBrands = Set.from(widget.selectedBrands);
    _selectedColorFilters = Set.from(widget.selectedColorFilters);
    _selectedSizes = Set.from(widget.selectedSizes);
    _showBeta = widget.showBeta;
  }

  void _clearAll() {
    setState(() {
      _sortOption = SortOption.sizeAsc;
      _selectedBrands = {};
      _selectedColorFilters = {};
      _selectedSizes = {};
      _showBeta = false;
    });
  }

  String _categoryLabel(_FilterCategory cat, AppLocalizations l) {
    switch (cat) {
      case _FilterCategory.sort:
        return l.sortBy;
      case _FilterCategory.brand:
        return l.brand;
      case _FilterCategory.color:
        return l.colors;
      case _FilterCategory.size:
        return l.size;
      case _FilterCategory.beta:
        return l.betaDisplays;
    }
  }

  int _categoryActiveCount(_FilterCategory cat) {
    switch (cat) {
      case _FilterCategory.sort:
        return _sortOption != SortOption.sizeAsc ? 1 : 0;
      case _FilterCategory.brand:
        return _selectedBrands.length;
      case _FilterCategory.color:
        return _selectedColorFilters.length;
      case _FilterCategory.size:
        return _selectedSizes.length;
      case _FilterCategory.beta:
        return _showBeta ? 1 : 0;
    }
  }

  Widget _buildLeftPanel(AppLocalizations l) {
    return Container(
      color: const Color(0xFFF2F2F2),
      child: ListView(
        children: _FilterCategory.values.map((cat) {
          final isSelected = cat == _activeCategory;
          final count = _categoryActiveCount(cat);
          return InkWell(
            onTap: () => setState(() => _activeCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingS, vertical: 18),
              decoration: BoxDecoration(
                color: isSelected ? colorWhite : const Color(0xFFF2F2F2),
                border: isSelected
                    ? const Border(
                        left: BorderSide(color: colorAccent, width: 3))
                    : const Border(
                        left: BorderSide(color: Colors.transparent, width: 3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _categoryLabel(cat, l),
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: Dimens.fontSizeM,
                        color: isSelected ? colorAccent : colorBlack,
                      ),
                    ),
                  ),
                  if (count > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: colorAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: colorWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRightPanelContent(AppLocalizations l) {
    switch (_activeCategory) {
      case _FilterCategory.sort:
        return RadioGroup<SortOption>(
          groupValue: _sortOption,
          onChanged: (val) {
            if (val != null) setState(() => _sortOption = val);
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: SortOption.values.map((option) {
              return RadioListTile<SortOption>(
                value: option,
                title: Text(option.label(l),
                    style: const TextStyle(fontSize: Dimens.fontSizeM)),
              );
            }).toList(),
          ),
        );
      case _FilterCategory.brand:
        return ListView(
          padding: EdgeInsets.zero,
          children: Brand.values.map((brand) {
            final selected = _selectedBrands.contains(brand);
            return CheckboxListTile(
              fillColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? colorAccent
                      : Colors.transparent),
              checkColor: colorWhite,
              side: const BorderSide(color: mdGrey400),
              value: selected,
              title: Text(brand.label(l),
                  style: TextStyle(
                      fontSize: Dimens.fontSizeM,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal)),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _selectedBrands.add(brand);
                  } else {
                    _selectedBrands.remove(brand);
                  }
                });
              },
            );
          }).toList(),
        );
      case _FilterCategory.color:
        return ListView(
          padding: EdgeInsets.zero,
          children: ColorFilter.values.map((c) {
            final selected = _selectedColorFilters.contains(c);
            return CheckboxListTile(
              fillColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? colorAccent
                      : Colors.transparent),
              checkColor: colorWhite,
              side: const BorderSide(color: mdGrey400),
              value: selected,
              title: Text(c.label(l),
                  style: TextStyle(
                      fontSize: Dimens.fontSizeM,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal)),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _selectedColorFilters.add(c);
                  } else {
                    _selectedColorFilters.remove(c);
                  }
                });
              },
            );
          }).toList(),
        );
      case _FilterCategory.size:
        return ListView(
          padding: EdgeInsets.zero,
          children: widget.availableSizes.map((size) {
            final selected = _selectedSizes.contains(size);
            return CheckboxListTile(
              fillColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? colorAccent
                      : Colors.transparent),
              checkColor: colorWhite,
              side: const BorderSide(color: mdGrey400),
              value: selected,
              title: Text(size,
                  style: TextStyle(
                      fontSize: Dimens.fontSizeM,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal)),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _selectedSizes.add(size);
                  } else {
                    _selectedSizes.remove(size);
                  }
                });
              },
            );
          }).toList(),
        );
      case _FilterCategory.beta:
        return ListView(
          padding: const EdgeInsets.all(Dimens.spacingM),
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(Dimens.radiusM),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: SwitchListTile(
                activeTrackColor: colorAccent,
                activeThumbColor: colorWhite,
                value: _showBeta,
                title: Text(l.showBetaDisplays,
                    style: const TextStyle(
                        fontSize: Dimens.fontSizeM,
                        fontWeight: FontWeight.w600)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(l.showBetaDisplaysTooltip,
                      style: const TextStyle(
                          fontSize: Dimens.fontSizeS, color: mdGrey400)),
                ),
                onChanged: (val) => setState(() => _showBeta = val),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildRightPanel(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingM, vertical: Dimens.spacingS),
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
          ),
          child: Text(
            _categoryLabel(_activeCategory, l),
            style: const TextStyle(
              fontSize: Dimens.fontSizeM,
              fontWeight: FontWeight.bold,
              color: colorBlack,
            ),
          ),
        ),
        Expanded(child: _buildRightPanelContent(l)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colorBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.filters,
          style: const TextStyle(
              color: colorBlack,
              fontWeight: FontWeight.bold,
              fontSize: Dimens.fontSizeL),
        ),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: Text(
              l.clearAll,
              style: const TextStyle(color: colorAccent),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Flexible(flex: 2, child: _buildLeftPanel(l)),
          const VerticalDivider(width: 1, thickness: 1),
          Flexible(flex: 3, child: _buildRightPanel(l)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingMd, vertical: Dimens.spacingS),
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: colorAccent),
            onPressed: () {
              Navigator.pop(
                context,
                _FilterResult(
                  sortOption: _sortOption,
                  selectedBrands: _selectedBrands,
                  selectedColorFilters: _selectedColorFilters,
                  selectedSizes: _selectedSizes,
                  showBeta: _showBeta,
                ),
              );
            },
            child: Text(l.apply),
          ),
        ),
      ),
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
