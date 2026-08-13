import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/menu_template_result.dart';
import 'package:magicepaperapp/card_templates/restaurant_menu_badge.dart';
import 'package:magicepaperapp/card_templates/restaurant_menu_card_widget.dart';
import 'package:magicepaperapp/card_templates/restaurant_menu_model.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';
import 'package:magicepaperapp/util/page_route_util.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

const List<String> _currencyOptions = ['\$', '€', '£', '₹', '¥'];
const int _maxItems = 5;

class _ItemControllers {
  final TextEditingController name;
  final TextEditingController price;
  final TextEditingController description;
  final TextEditingController category;
  final Set<DietaryTag> tags;
  FoodType foodType;

  _ItemControllers({
    String name = '',
    String price = '',
    String description = '',
    String category = '',
    Set<DietaryTag>? tags,
    this.foodType = FoodType.none,
  })  : name = TextEditingController(text: name),
        price = TextEditingController(text: price),
        description = TextEditingController(text: description),
        category = TextEditingController(text: category),
        tags = tags ?? <DietaryTag>{};

  bool get isSpecial => tags.contains(DietaryTag.chefSpecial);

  void dispose() {
    name.dispose();
    price.dispose();
    description.dispose();
    category.dispose();
  }

  MenuItem toItem() => MenuItem(
        name: name.text.trim(),
        price: price.text.trim(),
        description: description.text.trim(),
        category: category.text.trim(),
        foodType: foodType,
        tags: Set<DietaryTag>.from(tags),
      );
}

class RestaurantMenuForm extends StatefulWidget {
  final int width;
  final int height;
  final Map<String, dynamic>? initialData;
  final bool fromLibrary;

  const RestaurantMenuForm({
    super.key,
    required this.width,
    required this.height,
    this.initialData,
    this.fromLibrary = false,
  });

  @override
  State<RestaurantMenuForm> createState() => _RestaurantMenuFormState();
}

class _RestaurantMenuFormState extends State<RestaurantMenuForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _dateController;
  late final TextEditingController _footerController;
  late final TextEditingController _menuUrlController;
  late String _currency;
  late MenuBoardStyle _style;
  final List<_ItemControllers> _items = <_ItemControllers>[];
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialData;
    if (initial != null) {
      final model = RestaurantMenuModel.fromJson(initial);
      _titleController = TextEditingController(text: model.title);
      _subtitleController = TextEditingController(text: model.subtitle);
      _dateController = TextEditingController(text: model.dateLabel);
      _footerController = TextEditingController(text: model.footer);
      _menuUrlController = TextEditingController(text: model.menuUrl);
      _currency = model.currency;
      _style = model.style;
      for (final item in model.items) {
        _items.add(_ItemControllers(
          name: item.name,
          price: item.price,
          description: item.description,
          category: item.category,
          foodType: item.foodType,
          tags: Set<DietaryTag>.from(item.tags),
        ));
      }
      if (_items.isEmpty) _items.add(_ItemControllers());
    } else {
      _titleController =
          TextEditingController(text: appLocalizations.menuSampleTitle);
      _subtitleController =
          TextEditingController(text: appLocalizations.menuSampleSubtitle);
      _dateController = TextEditingController(text: _todayLabel());
      _footerController = TextEditingController();
      _menuUrlController =
          TextEditingController(text: appLocalizations.menuSampleUrl);
      _currency = '₹';
      _style = MenuBoardStyle.list;
      _items.addAll([
        _ItemControllers(
          name: appLocalizations.menuSampleItem1Name,
          price: '180',
          foodType: FoodType.veg,
        ),
        _ItemControllers(
          name: appLocalizations.menuSampleItem2Name,
          price: '320',
          foodType: FoodType.nonVeg,
          tags: {DietaryTag.chefSpecial},
        ),
        _ItemControllers(
          name: appLocalizations.menuSampleItem3Name,
          price: '240',
          foodType: FoodType.veg,
        ),
      ]);
    }
    _attachListeners();
  }

  String _todayLabel() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = DateTime.now();
    return '${appLocalizations.menuToday} · ${now.day} ${months[now.month - 1]}';
  }

  void _attachListeners() {
    _titleController.addListener(_onChanged);
    _subtitleController.addListener(_onChanged);
    _dateController.addListener(_onChanged);
    _footerController.addListener(_onChanged);
    _menuUrlController.addListener(_onChanged);
    for (final item in _items) {
      item.name.addListener(_onChanged);
      item.price.addListener(_onChanged);
      item.description.addListener(_onChanged);
      item.category.addListener(_onChanged);
    }
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _dateController.dispose();
    _footerController.dispose();
    _menuUrlController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  RestaurantMenuModel _buildModel() {
    return RestaurantMenuModel(
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      dateLabel: _dateController.text.trim(),
      currency: _currency,
      footer: _footerController.text.trim(),
      style: _style,
      menuUrl: _menuUrlController.text.trim(),
      items: _items.map((c) => c.toItem()).toList(),
    );
  }

  void _addItem() {
    if (_items.length >= _maxItems) return;
    final item = _ItemControllers();
    item.name.addListener(_onChanged);
    item.price.addListener(_onChanged);
    item.description.addListener(_onChanged);
    item.category.addListener(_onChanged);
    setState(() => _items.add(item));
  }

  void _setFoodType(int index, FoodType type) {
    setState(() {
      _items[index].foodType =
          _items[index].foodType == type ? FoodType.none : type;
    });
  }

  void _toggleSpecial(int index) {
    _toggleTag(index, DietaryTag.chefSpecial);
  }

  void _removeItem(int index) {
    final removed = _items.removeAt(index);
    removed.dispose();
    setState(() {});
  }

  void _toggleTag(int index, DietaryTag tag) {
    final tags = _items[index].tags;
    setState(() {
      if (tags.contains(tag)) {
        tags.remove(tag);
      } else {
        tags.add(tag);
      }
    });
  }

  Future<void> _submitForm() async {
    final model = _buildModel();
    if (model.style == MenuBoardStyle.scanToView) {
      if (model.menuUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appLocalizations.menuAddLinkFirst)),
        );
        return;
      }
    } else if (model.visibleItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.menuAddItemFirst)),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isGenerating = true);

    try {
      final layers = <LayerSpec>[
        LayerSpec.widget(
          widget: SizedBox(
            width: widget.width.toDouble(),
            height: widget.height.toDouble(),
            child: RestaurantMenuBadge(menu: model),
          ),
          kind: LayerKind.generic,
          elementId: 'restaurantMenu',
        ),
      ];

      final result = await Navigator.of(context).push<Object>(
        buildOpaqueSlideRoute(
          NativeCanvasEditor(
            width: widget.width,
            height: widget.height,
            initialLayers: layers,
          ),
        ),
      );

      if (!mounted) return;
      if (result is Uint8List) {
        final out = MenuTemplateResult(result, model.toJson());
        if (widget.fromLibrary) {
          Navigator.of(context).pop(out);
        } else {
          Navigator.of(context)
            ..pop()
            ..pop(out);
        }
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = _buildModel();
    return CommonScaffold(
      index: -1,
      showBackButton: true,
      titleWidget: Text(
        appLocalizations.restaurantMenuTitle,
        style: const TextStyle(
          fontSize: Dimens.fontSizeXxl,
          fontWeight: FontWeight.bold,
          color: colorWhite,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimens.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.menuPreviewTitle,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacingM),
              RestaurantMenuCardWidget(
                menu: model,
                width: widget.width,
                height: widget.height,
              ),
              const SizedBox(height: Dimens.spacingXl),
              const Divider(height: 1, color: grey500),
              const SizedBox(height: Dimens.spacingXl),
              _buildStyleCard(),
              const SizedBox(height: Dimens.spacingL),
              _buildHeaderCard(),
              const SizedBox(height: Dimens.spacingL),
              if (_style == MenuBoardStyle.scanToView)
                _buildLinkCard()
              else
                _buildItemsCard(),
              const SizedBox(height: Dimens.spacingXxl),
              _buildGenerateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Card(
      color: colorWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        side: BorderSide(color: grey300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingXl),
        child: child,
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: colorAccent, size: Dimens.iconSizeM),
        const SizedBox(width: Dimens.spacingS),
        Text(
          label,
          style: const TextStyle(
            fontSize: Dimens.fontSizeXl,
            fontWeight: FontWeight.bold,
            color: colorBlack,
          ),
        ),
      ],
    );
  }

  void _setStyle(MenuBoardStyle style) {
    if (_style == style) return;
    setState(() => _style = style);
  }

  Widget _buildStyleCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.dashboard_customize_outlined,
              appLocalizations.menuStyleSection),
          const SizedBox(height: Dimens.spacingS),
          Text(
            appLocalizations.menuStyleHint,
            style: TextStyle(
              fontSize: Dimens.fontSizeXs,
              color: grey600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: Dimens.spacingM),
          Row(
            children: [
              Expanded(
                child: _styleOption(
                  style: MenuBoardStyle.list,
                  icon: Icons.list_alt,
                  label: appLocalizations.menuStyleList,
                ),
              ),
              const SizedBox(width: Dimens.spacingM),
              Expanded(
                child: _styleOption(
                  style: MenuBoardStyle.scanToView,
                  icon: Icons.qr_code_2,
                  label: appLocalizations.menuStyleScan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _styleOption({
    required MenuBoardStyle style,
    required IconData icon,
    required String label,
  }) {
    final selected = _style == style;
    return InkWell(
      onTap: _isGenerating ? null : () => _setStyle(style),
      borderRadius: BorderRadius.circular(Dimens.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.spacingM,
          horizontal: Dimens.spacingS,
        ),
        decoration: BoxDecoration(
          color: selected ? colorPrimary.withValues(alpha: 0.08) : grey50,
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          border: Border.all(
            color: selected ? colorPrimary : grey300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: Dimens.iconSizeL,
                color: selected ? colorPrimary : grey600),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimens.fontSizeS,
                fontWeight: FontWeight.w700,
                color: selected ? colorPrimary : colorBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.link, appLocalizations.menuLinkSection),
          const SizedBox(height: Dimens.spacingXs),
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 14, color: grey600),
              const SizedBox(width: Dimens.spacingXs),
              Expanded(
                child: Text(
                  appLocalizations.menuLinkHint,
                  style: TextStyle(
                    fontSize: Dimens.fontSizeXs,
                    color: grey600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacingM),
          _textField(
            controller: _menuUrlController,
            label: appLocalizations.menuLinkLabel,
            hint: appLocalizations.menuLinkHintField,
            icon: Icons.qr_code_2,
            keyboardType: TextInputType.url,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
              Icons.storefront_outlined, appLocalizations.menuHeaderSection),
          const SizedBox(height: Dimens.spacingL),
          _textField(
            controller: _titleController,
            label: appLocalizations.menuTitleLabel,
            hint: appLocalizations.menuTitleHint,
            icon: Icons.title,
          ),
          const SizedBox(height: Dimens.spacingM),
          _textField(
            controller: _subtitleController,
            label: appLocalizations.menuSubtitleLabel,
            hint: appLocalizations.menuSubtitleHint,
            icon: Icons.subtitles_outlined,
          ),
          const SizedBox(height: Dimens.spacingM),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _textField(
                  controller: _dateController,
                  label: appLocalizations.menuDateLabel,
                  hint: appLocalizations.menuDateHint,
                  icon: Icons.event_outlined,
                ),
              ),
              const SizedBox(width: Dimens.spacingS),
              TextButton.icon(
                onPressed: _isGenerating
                    ? null
                    : () => _dateController.text = _todayLabel(),
                style: TextButton.styleFrom(foregroundColor: colorPrimary),
                icon: const Icon(Icons.today, size: 18),
                label: Text(appLocalizations.menuUseToday),
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacingL),
          Text(
            appLocalizations.menuCurrencyLabel,
            style: TextStyle(
              fontSize: Dimens.fontSizeM,
              fontWeight: FontWeight.w600,
              color: colorBlack.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: Dimens.spacingS),
          Wrap(
            spacing: Dimens.spacingS,
            children: [
              for (final option in _currencyOptions)
                ChoiceChip(
                  label: Text(option),
                  selected: _currency == option,
                  showCheckmark: false,
                  onSelected: _isGenerating
                      ? null
                      : (_) => setState(() => _currency = option),
                  selectedColor: colorPrimary,
                  labelStyle: TextStyle(
                    color: _currency == option ? colorWhite : colorBlack,
                    fontWeight: FontWeight.w700,
                  ),
                  backgroundColor: grey50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radiusL),
                    side: BorderSide(
                        color: _currency == option ? colorPrimary : grey300),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _sectionTitle(
                    Icons.restaurant_menu, appLocalizations.menuItemsSection),
              ),
              Text(
                '${_items.length}/$_maxItems',
                style: TextStyle(
                  fontSize: Dimens.fontSizeS,
                  fontWeight: FontWeight.w600,
                  color: grey600,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacingXs),
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 14, color: grey600),
              const SizedBox(width: Dimens.spacingXs),
              Expanded(
                child: Text(
                  appLocalizations.menuItemsHint,
                  style: TextStyle(
                    fontSize: Dimens.fontSizeXs,
                    color: grey600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacingM),
          for (var i = 0; i < _items.length; i++) _buildItemEditor(i),
          const SizedBox(height: Dimens.spacingS),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: (_isGenerating || _items.length >= _maxItems)
                  ? null
                  : _addItem,
              style: OutlinedButton.styleFrom(
                foregroundColor: colorPrimary,
                side: BorderSide(color: colorPrimary.withValues(alpha: 0.6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusM),
                ),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: Text(appLocalizations.menuAddItem),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemEditor(int index) {
    final item = _items[index];
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.spacingM),
      padding: const EdgeInsets.all(Dimens.spacingM),
      decoration: BoxDecoration(
        color: grey50,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(color: grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimens.radiusS),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeS,
                    fontWeight: FontWeight.bold,
                    color: colorPrimary,
                  ),
                ),
              ),
              const SizedBox(width: Dimens.spacingS),
              Expanded(
                child: _textField(
                  controller: item.name,
                  label: appLocalizations.menuItemNameLabel,
                  hint: appLocalizations.menuItemNameHint,
                  dense: true,
                ),
              ),
              IconButton(
                onPressed: (_isGenerating || _items.length <= 1)
                    ? null
                    : () => _removeItem(index),
                icon: const Icon(Icons.delete_outline),
                color: colorPrimary,
                tooltip: appLocalizations.menuRemoveItem,
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacingS),
          _textField(
            controller: item.price,
            label: appLocalizations.menuItemPriceLabel,
            hint: appLocalizations.menuItemPriceHint,
            dense: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixText: _currency,
          ),
          const SizedBox(height: Dimens.spacingM),
          _fieldLabel(appLocalizations.menuFoodType),
          const SizedBox(height: Dimens.spacingXs),
          Wrap(
            spacing: Dimens.spacingS,
            runSpacing: Dimens.spacingXs,
            children: [
              for (final type in FoodType.values)
                if (type != FoodType.none) _foodTypeChip(index, item, type),
            ],
          ),
          const SizedBox(height: Dimens.spacingM),
          _categoryField(index, item),
          const SizedBox(height: Dimens.spacingM),
          Row(
            children: [
              Icon(Icons.star,
                  size: 18, color: item.isSpecial ? colorPrimary : grey500),
              const SizedBox(width: Dimens.spacingS),
              Expanded(
                child: Text(
                  appLocalizations.menuMarkSpecial,
                  style: TextStyle(
                    fontSize: Dimens.fontSizeS,
                    fontWeight: FontWeight.w600,
                    color: colorBlack.withValues(alpha: 0.8),
                  ),
                ),
              ),
              Switch(
                value: item.isSpecial,
                onChanged: _isGenerating ? null : (_) => _toggleSpecial(index),
                activeThumbColor: colorPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Dimens.fontSizeS,
        fontWeight: FontWeight.w600,
        color: colorBlack.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _foodTypeChip(int index, _ItemControllers item, FoodType type) {
    final selected = item.foodType == type;
    return ChoiceChip(
      avatar: _FoodTypeGlyph(
        type: type,
        color: selected ? colorWhite : colorBlack,
      ),
      label: Text(_foodTypeLabel(type)),
      selected: selected,
      showCheckmark: false,
      onSelected: _isGenerating ? null : (_) => _setFoodType(index, type),
      selectedColor: colorPrimary,
      labelStyle: TextStyle(
        fontSize: Dimens.fontSizeS,
        color: selected ? colorWhite : colorBlack,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        side: BorderSide(color: selected ? colorPrimary : grey300),
      ),
    );
  }

  Widget _categoryField(int index, _ItemControllers item) {
    final presets = <String>[
      appLocalizations.menuCatStarters,
      appLocalizations.menuCatMains,
      appLocalizations.menuCatBreads,
      appLocalizations.menuCatRice,
      appLocalizations.menuCatBeverages,
      appLocalizations.menuCatDesserts,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textField(
          controller: item.category,
          label: appLocalizations.menuCategoryLabel,
          hint: appLocalizations.menuCategoryHint,
          dense: true,
        ),
        const SizedBox(height: Dimens.spacingXs),
        Wrap(
          spacing: Dimens.spacingXs,
          runSpacing: Dimens.spacingXs,
          children: [
            for (final preset in presets)
              ActionChip(
                label: Text(preset),
                onPressed:
                    _isGenerating ? null : () => item.category.text = preset,
                labelStyle: TextStyle(
                  fontSize: Dimens.fontSizeXs,
                  color: colorBlack.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
                backgroundColor: grey100,
                side: BorderSide(color: grey300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusL),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ],
    );
  }

  String _foodTypeLabel(FoodType type) {
    switch (type) {
      case FoodType.none:
        return appLocalizations.menuFoodNone;
      case FoodType.veg:
        return appLocalizations.menuFoodVeg;
      case FoodType.nonVeg:
        return appLocalizations.menuFoodNonVeg;
      case FoodType.egg:
        return appLocalizations.menuFoodEgg;
    }
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    bool dense = false,
    TextInputType? keyboardType,
    String? prefixText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: colorPrimary,
      style: const TextStyle(fontSize: Dimens.fontSizeM, color: colorBlack),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: dense,
        prefixIcon: icon != null
            ? Icon(icon, color: colorAccent, size: Dimens.iconSizeM)
            : null,
        prefixText: prefixText,
        labelStyle: TextStyle(
          color: colorBlack.withValues(alpha: 0.7),
          fontSize: Dimens.fontSizeM,
        ),
        floatingLabelStyle: const TextStyle(
          color: colorPrimary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(color: grey500, fontSize: Dimens.fontSizeS),
        filled: true,
        fillColor: dense ? colorWhite : grey50,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimens.spacingM,
          vertical: dense ? Dimens.spacingS : 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          borderSide: BorderSide(color: grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          borderSide: BorderSide(color: grey300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          borderSide: const BorderSide(color: colorPrimary, width: 2),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    final enabled = !_isGenerating;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: enabled ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimary.withValues(alpha: enabled ? 1.0 : 0.49),
          foregroundColor: colorWhite,
          disabledBackgroundColor: colorPrimary.withValues(alpha: 0.4),
          disabledForegroundColor: colorWhite.withValues(alpha: 0.7),
          elevation: enabled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
        ),
        child: _isGenerating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colorWhite),
                    ),
                  ),
                  const SizedBox(width: Dimens.spacingM),
                  Text(
                    appLocalizations.menuGenerating,
                    style: const TextStyle(
                        fontSize: Dimens.fontSizeL,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.restaurant_menu, size: 18),
                  const SizedBox(width: Dimens.spacingS),
                  Text(
                    appLocalizations.menuGenerate,
                    style: const TextStyle(
                        fontSize: Dimens.fontSizeL,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FoodTypeGlyph extends StatelessWidget {
  final FoodType type;
  final Color color;

  const _FoodTypeGlyph({required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child:
          CustomPaint(painter: _FoodTypeGlyphPainter(type: type, color: color)),
    );
  }
}

class _FoodTypeGlyphPainter extends CustomPainter {
  final FoodType type;
  final Color color;

  _FoodTypeGlyphPainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final stroke = s * 0.12;
    final border = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final inset = stroke / 2;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(inset, inset, s - stroke, s - stroke),
      Radius.circular(s * 0.16),
    );
    canvas.drawRRect(rect, border);

    final center = Offset(s / 2, s / 2);
    final glyph = s * 0.28;
    switch (type) {
      case FoodType.none:
        break;
      case FoodType.veg:
        canvas.drawCircle(center, glyph, fill);
        break;
      case FoodType.egg:
        canvas.drawCircle(
          center,
          glyph,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.1,
        );
        break;
      case FoodType.nonVeg:
        final path = Path()
          ..moveTo(center.dx, center.dy - glyph)
          ..lineTo(center.dx + glyph, center.dy + glyph)
          ..lineTo(center.dx - glyph, center.dy + glyph)
          ..close();
        canvas.drawPath(path, fill);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _FoodTypeGlyphPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.color != color;
}
