import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/native_canvas/sticker_vault/iconify_service.dart';

class _StickerCategory {
  const _StickerCategory(this.label, this.icons);
  final String label;
  final List<String> icons;
}

const List<_StickerCategory> _categories = [
  _StickerCategory('Popular', [
    'mdi:heart', 'mdi:star', 'mdi:home', 'mdi:map-marker', 'mdi:gift',
    'mdi:tag', 'mdi:camera', 'mdi:music', 'mdi:fire', 'mdi:crown',
    'mdi:diamond-stone', 'mdi:flash', 'mdi:check-decagram', 'mdi:bell',
    'mdi:thumb-up', 'mdi:emoticon-happy', 'mdi:lightbulb-on', 'mdi:rocket',
  ]),
  _StickerCategory('Faces', [
    'mdi:emoticon-happy', 'mdi:emoticon-cool', 'mdi:emoticon-wink',
    'mdi:emoticon-excited', 'mdi:emoticon-sad', 'mdi:emoticon-cry',
    'mdi:emoticon-angry', 'mdi:emoticon-kiss', 'mdi:emoticon-neutral',
    'mdi:emoticon-tongue', 'mdi:heart', 'mdi:heart-broken',
  ]),
  _StickerCategory('Weather', [
    'mdi:weather-sunny', 'mdi:weather-night', 'mdi:weather-cloudy',
    'mdi:weather-partly-cloudy', 'mdi:weather-rainy', 'mdi:weather-pouring',
    'mdi:weather-snowy', 'mdi:weather-lightning', 'mdi:weather-windy',
    'mdi:weather-fog', 'mdi:snowflake', 'mdi:umbrella',
  ]),
  _StickerCategory('Food', [
    'mdi:food', 'mdi:coffee', 'mdi:pizza', 'mdi:hamburger', 'mdi:cupcake',
    'mdi:cake-variant', 'mdi:ice-cream', 'mdi:food-apple', 'mdi:bottle-soda',
    'mdi:glass-cocktail', 'mdi:silverware-fork-knife', 'mdi:cup',
  ]),
  _StickerCategory('Nature', [
    'mdi:leaf', 'mdi:flower', 'mdi:tree', 'mdi:pine-tree', 'mdi:sprout',
    'mdi:cactus', 'mdi:mushroom', 'mdi:water', 'mdi:fire', 'mdi:paw',
    'mdi:bee', 'mdi:butterfly',
  ]),
  _StickerCategory('Tech', [
    'mdi:cellphone', 'mdi:laptop', 'mdi:monitor', 'mdi:wifi', 'mdi:bluetooth',
    'mdi:battery', 'mdi:camera', 'mdi:headphones', 'mdi:usb', 'mdi:printer',
    'mdi:cog', 'mdi:robot',
  ]),
  _StickerCategory('Business', [
    'mdi:briefcase', 'mdi:currency-usd', 'mdi:chart-line', 'mdi:cart',
    'mdi:credit-card', 'mdi:calendar', 'mdi:email', 'mdi:phone',
    'mdi:office-building', 'mdi:handshake', 'mdi:clipboard-text', 'mdi:tag',
  ]),
  _StickerCategory('Travel', [
    'mdi:airplane', 'mdi:car', 'mdi:bicycle', 'mdi:bus', 'mdi:train',
    'mdi:map-marker', 'mdi:compass', 'mdi:bag-suitcase', 'mdi:ferry',
    'mdi:rocket', 'mdi:earth', 'mdi:tent',
  ]),
  _StickerCategory('Arrows', [
    'mdi:arrow-up', 'mdi:arrow-down', 'mdi:arrow-left', 'mdi:arrow-right',
    'mdi:arrow-top-right', 'mdi:arrow-bottom-left', 'mdi:chevron-right',
    'mdi:chevron-left', 'mdi:refresh', 'mdi:undo', 'mdi:redo', 'mdi:sync',
  ]),
  _StickerCategory('Shapes', [
    'mdi:circle', 'mdi:square', 'mdi:triangle', 'mdi:star', 'mdi:heart',
    'mdi:hexagon', 'mdi:rhombus', 'mdi:octagon', 'mdi:cards-diamond',
    'mdi:cards-club', 'mdi:cards-spade', 'mdi:cards-heart',
  ]),
  _StickerCategory('Symbols', [
    'mdi:check-bold', 'mdi:close-thick', 'mdi:plus-thick', 'mdi:minus-thick',
    'mdi:alert', 'mdi:information', 'mdi:help-circle', 'mdi:lightbulb',
    'mdi:key', 'mdi:lock', 'mdi:bookmark', 'mdi:flag',
  ]),
];

Future<Uint8List?> showStickerVault(
  BuildContext context, {
  required Color inkColor,
}) {
  return showModalBottomSheet<Uint8List>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _StickerVaultSheet(inkColor: inkColor),
  );
}

class _StickerVaultSheet extends StatefulWidget {
  const _StickerVaultSheet({required this.inkColor});

  final Color inkColor;

  @override
  State<_StickerVaultSheet> createState() => _StickerVaultSheetState();
}

class _StickerVaultSheetState extends State<_StickerVaultSheet> {
  final IconifyService _service = IconifyService();
  final TextEditingController _searchCtrl = TextEditingController();
  final Color _previewColor = grey900;

  Timer? _debounce;
  int _categoryIndex = 0;
  String _query = '';

  List<String> _results = const [];
  bool _loading = false;
  Object? _error;

  String? _placing;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _service.dispose();
    super.dispose();
  }

  bool get _isSearching => _query.trim().isNotEmpty;

  List<String> get _visibleIcons =>
      _isSearching ? _results : _categories[_categoryIndex].icons;

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    setState(() => _query = value);
    if (value.trim().isEmpty) {
      setState(() {
        _results = const [];
        _error = null;
        _loading = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), _runSearch);
  }

  Future<void> _runSearch() async {
    final query = _query.trim();
    if (query.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final icons = await _service.search(query);
      if (!mounted || query != _query.trim()) return;
      setState(() {
        _results = icons;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _pick(String iconName) async {
    if (_placing != null) return;
    setState(() => _placing = iconName);
    try {
      final bytes =
          await _service.fetchPng(iconName, color: widget.inkColor);
      if (!mounted) return;
      Navigator.pop(context, bytes);
    } catch (e) {
      if (!mounted) return;
      setState(() => _placing = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(),
              _buildSearchField(),
              if (!_isSearching) _buildCategoryChips(),
              const SizedBox(height: 4),
              Expanded(child: _buildBody(scrollController)),
              _buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: grey300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 8, 6),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: colorAccent, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sticker Vault',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorBlack87,
                ),
              ),
              Text(
                'Free, open-licensed icons & stickers',
                style: TextStyle(fontSize: 12, color: grey600),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            color: grey600,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: TextField(
        controller: _searchCtrl,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _runSearch(),
        decoration: InputDecoration(
          hintText: 'Search thousands of stickers…',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    _onSearchChanged('');
                  },
                ),
          isDense: true,
          filled: true,
          fillColor: grey100,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == _categoryIndex;
          return Center(
            child: ChoiceChip(
              label: Text(_categories[index].label),
              selected: selected,
              showCheckmark: false,
              onSelected: (_) => setState(() => _categoryIndex = index),
              selectedColor: colorAccent,
              backgroundColor: grey100,
              labelStyle: TextStyle(
                color: selected ? colorWhite : colorBlack87,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              side: BorderSide(color: selected ? colorAccent : grey300),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(ScrollController scrollController) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: colorAccent),
      );
    }
    if (_error != null) {
      return _buildMessage(
        icon: Icons.wifi_off,
        title: 'Couldn\'t load stickers',
        subtitle: 'Check your connection and try again.',
        action: TextButton(
          onPressed: _runSearch,
          child: const Text('Retry'),
        ),
      );
    }
    final icons = _visibleIcons;
    if (icons.isEmpty) {
      return _buildMessage(
        icon: Icons.search_off,
        title: 'No stickers found',
        subtitle: 'Try a different word, like “star” or “coffee”.',
      );
    }
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) => _buildTile(icons[index]),
    );
  }

  Widget _buildTile(String iconName) {
    final isPlacing = _placing == iconName;
    return Material(
      color: grey100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _pick(iconName),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: isPlacing
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorAccent,
                    ),
                  ),
                )
              : SvgPicture.network(
                  _service.previewUrl(iconName, color: _previewColor),
                  fit: BoxFit.contain,
                  placeholderBuilder: (_) => Center(
                    child: Icon(Icons.image_outlined, color: grey400, size: 20),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: grey400),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: colorBlack87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: grey600, fontSize: 13),
            ),
            if (action != null) ...[const SizedBox(height: 8), action],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 14, color: grey500),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Powered by Iconify — open-source (CC0 / MIT / Apache) icons',
                style: TextStyle(fontSize: 11, color: grey500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
