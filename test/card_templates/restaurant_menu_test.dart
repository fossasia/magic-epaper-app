import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/card_templates/restaurant_menu_badge.dart';
import 'package:magicepaperapp/card_templates/restaurant_menu_model.dart';

void main() {
  RestaurantMenuModel sample({int items = 3, bool footer = true}) {
    const categories = ['Starters', 'Main Course', 'Beverages'];
    const foods = [FoodType.veg, FoodType.nonVeg, FoodType.egg];
    return RestaurantMenuModel(
      title: "Today's Specials",
      subtitle: 'THE CORNER CAFE',
      dateLabel: 'Today · 12 Aug',
      currency: '₹',
      footer: footer ? 'All prices include tax' : '',
      items: [
        for (var i = 0; i < items; i++)
          MenuItem(
            name: 'Dish number ${i + 1} with a fairly long name',
            description: i.isEven ? 'A tasty little description here' : '',
            price: '${100 + i * 10}',
            category: categories[(i ~/ 2) % categories.length],
            foodType: foods[i % foods.length],
            tags: i == 0
                ? {DietaryTag.vegan, DietaryTag.spicy}
                : (i == 1 ? {DietaryTag.chefSpecial} : const <DietaryTag>{}),
          ),
      ],
    );
  }

  group('RestaurantMenuModel', () {
    test('visibleItems drops empty rows', () {
      final model = RestaurantMenuModel(
        title: 'X',
        items: const [
          MenuItem(name: 'Soup', price: '5'),
          MenuItem(name: '', price: ''),
          MenuItem(name: 'Salad', price: '7'),
        ],
      );
      expect(model.visibleItems, hasLength(2));
      expect(model.hasAnyData, isTrue);
    });

    test('round-trips through JSON including tags', () {
      final model = sample();
      final restored = RestaurantMenuModel.fromJson(model.toJson());
      expect(restored.title, model.title);
      expect(restored.subtitle, model.subtitle);
      expect(restored.currency, model.currency);
      expect(restored.footer, model.footer);
      expect(restored.items.length, model.items.length);
      expect(restored.items.first.tags, contains(DietaryTag.vegan));
      expect(restored.items.first.tags, contains(DietaryTag.spicy));
      expect(restored.items.first.foodType, model.items.first.foodType);
      expect(restored.items.first.category, model.items.first.category);
      expect(restored.items[1].tags, contains(DietaryTag.chefSpecial));
    });

    test('toJson tags survive and ignores unknown tag names', () {
      final json = {
        'type': 'menu',
        'title': 'M',
        'items': [
          {
            'name': 'A',
            'price': '1',
            'tags': ['veg', 'bogus', 'vegan'],
          },
        ],
      };
      final restored = RestaurantMenuModel.fromJson(json);
      expect(restored.items.first.tags, {DietaryTag.veg, DietaryTag.vegan});
    });

    test('round-trips foodType, category and dateLabel', () {
      final model = RestaurantMenuModel(
        title: 'M',
        dateLabel: 'Today · 12 Aug',
        items: const [
          MenuItem(
            name: 'Paneer Tikka',
            price: '180',
            category: 'Starters',
            foodType: FoodType.veg,
          ),
          MenuItem(
            name: 'Butter Chicken',
            price: '320',
            category: 'Mains',
            foodType: FoodType.nonVeg,
          ),
        ],
      );
      final restored = RestaurantMenuModel.fromJson(model.toJson());
      expect(restored.dateLabel, 'Today · 12 Aug');
      expect(restored.items.first.foodType, FoodType.veg);
      expect(restored.items.first.category, 'Starters');
      expect(restored.items[1].foodType, FoodType.nonVeg);
    });

    test('unknown foodType falls back to none', () {
      final restored = MenuItem.fromJson({
        'name': 'A',
        'price': '1',
        'foodType': 'bogus',
      });
      expect(restored.foodType, FoodType.none);
    });

    test('entries insert a heading only when the section changes', () {
      final model = RestaurantMenuModel(
        title: 'M',
        items: const [
          MenuItem(name: 'A', price: '1', category: 'Starters'),
          MenuItem(name: 'B', price: '2', category: 'Starters'),
          MenuItem(name: 'C', price: '3', category: 'Mains'),
          MenuItem(name: 'D', price: '4'),
        ],
      );
      final entries = model.entries;
      final headings =
          entries.where((e) => e.isHeading).map((e) => e.heading).toList();
      expect(headings, ['Starters', 'Mains']);
      expect(entries.where((e) => !e.isHeading), hasLength(4));
    });

    test('isSpecial reflects the chefSpecial tag', () {
      const plain = MenuItem(name: 'A', price: '1');
      const special =
          MenuItem(name: 'B', price: '2', tags: {DietaryTag.chefSpecial});
      expect(plain.isSpecial, isFalse);
      expect(special.isSpecial, isTrue);
    });

    test('defaults to list style with no menu link', () {
      const model = RestaurantMenuModel(title: 'M');
      expect(model.style, MenuBoardStyle.list);
      expect(model.menuUrl, '');
    });

    test('round-trips board style and menu link', () {
      const model = RestaurantMenuModel(
        title: 'M',
        style: MenuBoardStyle.scanToView,
        menuUrl: 'https://menu.example.com',
      );
      final restored = RestaurantMenuModel.fromJson(model.toJson());
      expect(restored.style, MenuBoardStyle.scanToView);
      expect(restored.menuUrl, 'https://menu.example.com');
    });

    test('unknown board style falls back to list', () {
      final restored = RestaurantMenuModel.fromJson({
        'title': 'M',
        'style': 'bogus',
      });
      expect(restored.style, MenuBoardStyle.list);
    });

    test('menuUrl alone counts as data', () {
      const model =
          RestaurantMenuModel(title: '', menuUrl: 'https://x.example.com');
      expect(model.hasAnyData, isTrue);
    });

    test('round-trips fontFamily', () {
      const model =
          RestaurantMenuModel(title: 'M', fontFamily: 'Playfair Display');
      final restored = RestaurantMenuModel.fromJson(model.toJson());
      expect(restored.fontFamily, 'Playfair Display');
    });

    test('fontFamily defaults to empty', () {
      const model = RestaurantMenuModel(title: 'M');
      expect(model.fontFamily, '');
      expect(RestaurantMenuModel.fromJson({'title': 'M'}).fontFamily, '');
    });
  });

  group('RestaurantMenuBadge renders without overflow', () {
    Future<void> pumpAt(
      WidgetTester tester,
      double w,
      double h, {
      int items = 3,
      bool footer = true,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: w,
                height: h,
                child: RestaurantMenuBadge(
                    menu: sample(items: items, footer: footer)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    testWidgets('296x128 landscape', (t) => pumpAt(t, 296, 128));
    testWidgets('250x122 landscape', (t) => pumpAt(t, 250, 122));
    testWidgets('128x296 portrait', (t) => pumpAt(t, 128, 296, items: 5));
    testWidgets('400x300 with max items', (t) => pumpAt(t, 400, 300, items: 8));
    testWidgets('no footer', (t) => pumpAt(t, 296, 128, footer: false));
    testWidgets('single item', (t) => pumpAt(t, 296, 128, items: 1));
  });

  group('RestaurantMenuBadge scan-to-view renders without overflow', () {
    Future<void> pumpScan(
      WidgetTester tester,
      double w,
      double h, {
      String url = 'https://menu.example.com',
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: w,
                height: h,
                child: RestaurantMenuBadge(
                  menu: RestaurantMenuModel(
                    title: 'The Corner Cafe',
                    subtitle: 'Fine Dining',
                    dateLabel: 'Today · 12 Aug',
                    style: MenuBoardStyle.scanToView,
                    menuUrl: url,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    testWidgets('296x128 landscape', (t) => pumpScan(t, 296, 128));
    testWidgets('250x122 landscape', (t) => pumpScan(t, 250, 122));
    testWidgets('128x296 portrait', (t) => pumpScan(t, 128, 296));
    testWidgets(
        'empty url shows placeholder', (t) => pumpScan(t, 296, 128, url: ''));
  });
}
