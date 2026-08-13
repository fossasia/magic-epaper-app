import 'package:flutter/material.dart';

enum DietaryTag { veg, vegan, glutenFree, spicy, chefSpecial }

extension DietaryTagInfo on DietaryTag {
  String get shortLabel {
    switch (this) {
      case DietaryTag.veg:
        return 'V';
      case DietaryTag.vegan:
        return 'VG';
      case DietaryTag.glutenFree:
        return 'GF';
      case DietaryTag.spicy:
        return 'S';
      case DietaryTag.chefSpecial:
        return '★';
    }
  }

  IconData? get icon {
    switch (this) {
      case DietaryTag.veg:
        return Icons.eco;
      case DietaryTag.vegan:
        return Icons.spa;
      case DietaryTag.glutenFree:
        return null;
      case DietaryTag.spicy:
        return Icons.local_fire_department;
      case DietaryTag.chefSpecial:
        return Icons.star;
    }
  }
}

DietaryTag? dietaryTagFromName(String name) {
  for (final tag in DietaryTag.values) {
    if (tag.name == name) return tag;
  }
  return null;
}

enum FoodType { none, veg, nonVeg, egg }

FoodType foodTypeFromName(String name) {
  for (final type in FoodType.values) {
    if (type.name == name) return type;
  }
  return FoodType.none;
}

enum MenuBoardStyle { list, scanToView }

MenuBoardStyle menuBoardStyleFromName(String name) {
  for (final style in MenuBoardStyle.values) {
    if (style.name == name) return style;
  }
  return MenuBoardStyle.list;
}

class MenuItem {
  final String name;
  final String description;
  final String price;
  final Set<DietaryTag> tags;
  final FoodType foodType;
  final String category;

  const MenuItem({
    required this.name,
    this.description = '',
    this.price = '',
    this.tags = const <DietaryTag>{},
    this.foodType = FoodType.none,
    this.category = '',
  });

  bool get isEmpty => name.trim().isEmpty && price.trim().isEmpty;

  bool get isSpecial => tags.contains(DietaryTag.chefSpecial);

  MenuItem copyWith({
    String? name,
    String? description,
    String? price,
    Set<DietaryTag>? tags,
    FoodType? foodType,
    String? category,
  }) {
    return MenuItem(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      foodType: foodType ?? this.foodType,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'tags': tags.map((t) => t.name).toList(),
        'foodType': foodType.name,
        'category': category,
      };

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'];
    final tags = <DietaryTag>{};
    if (rawTags is List) {
      for (final t in rawTags) {
        final tag = dietaryTagFromName(t.toString());
        if (tag != null) tags.add(tag);
      }
    }
    return MenuItem(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as String? ?? '',
      tags: tags,
      foodType: foodTypeFromName(json['foodType'] as String? ?? 'none'),
      category: json['category'] as String? ?? '',
    );
  }
}

class MenuEntry {
  final String? heading;
  final MenuItem? item;

  const MenuEntry.heading(String this.heading) : item = null;
  const MenuEntry.item(MenuItem this.item) : heading = null;

  bool get isHeading => heading != null;
}

class RestaurantMenuModel {
  final String title;
  final String subtitle;
  final String dateLabel;
  final String currency;
  final List<MenuItem> items;
  final String footer;
  final MenuBoardStyle style;
  final String menuUrl;

  const RestaurantMenuModel({
    required this.title,
    this.subtitle = '',
    this.dateLabel = '',
    this.currency = '\$',
    this.items = const <MenuItem>[],
    this.footer = '',
    this.style = MenuBoardStyle.list,
    this.menuUrl = '',
  });

  List<MenuItem> get visibleItems =>
      items.where((i) => !i.isEmpty).toList(growable: false);

  List<MenuEntry> get entries {
    final result = <MenuEntry>[];
    var current = '';
    for (final item in visibleItems) {
      final category = item.category.trim();
      if (category.isNotEmpty && category != current) {
        current = category;
        result.add(MenuEntry.heading(category));
      }
      result.add(MenuEntry.item(item));
    }
    return result;
  }

  bool get hasAnyData =>
      title.trim().isNotEmpty ||
      subtitle.trim().isNotEmpty ||
      dateLabel.trim().isNotEmpty ||
      footer.trim().isNotEmpty ||
      menuUrl.trim().isNotEmpty ||
      visibleItems.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'type': 'menu',
        'title': title,
        'subtitle': subtitle,
        'dateLabel': dateLabel,
        'currency': currency,
        'footer': footer,
        'style': style.name,
        'menuUrl': menuUrl,
        'items': items.map((i) => i.toJson()).toList(),
      };

  factory RestaurantMenuModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = <MenuItem>[];
    if (rawItems is List) {
      for (final raw in rawItems) {
        if (raw is Map) {
          items.add(MenuItem.fromJson(Map<String, dynamic>.from(raw)));
        }
      }
    }
    return RestaurantMenuModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      dateLabel: json['dateLabel'] as String? ?? '',
      currency: json['currency'] as String? ?? '\$',
      footer: json['footer'] as String? ?? '',
      style: menuBoardStyleFromName(json['style'] as String? ?? 'list'),
      menuUrl: json['menuUrl'] as String? ?? '',
      items: items,
    );
  }
}
