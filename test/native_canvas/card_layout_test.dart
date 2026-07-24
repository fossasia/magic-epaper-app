import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_element.dart';
import 'package:magicepaperapp/native_canvas/model/card_layout.dart';
import 'package:magicepaperapp/util/template_util.dart';

void main() {
  const palette = [Colors.white, Colors.black];

  test('card layout is used when a qr layer is present', () {
    final layers = <LayerSpec>[
      const LayerSpec.text(
        text: 'Big Event',
        textStyle: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        elementId: 'eventName',
      ),
      const LayerSpec.text(
        text: 'Name: Alice',
        textStyle: TextStyle(fontSize: 16),
        elementId: 'attendeeName',
      ),
      LayerSpec.widget(
        widget: const SizedBox(width: 60, height: 60),
        kind: LayerKind.barcode,
        elementId: 'qr',
      ),
    ];

    final elements = buildTemplateElements(
      width: 416,
      height: 240,
      palette: palette,
      layers: layers,
    );

    expect(elements.length, 3);
    final qr = elements.firstWhere((e) => e.elementId == 'qr');
    expect(qr.kind, CanvasElementKind.widget);
    for (final e in elements) {
      expect(e.position.dx, greaterThanOrEqualTo(0));
      expect(e.position.dx, lessThanOrEqualTo(416));
      expect(e.position.dy, greaterThanOrEqualTo(0));
      expect(e.position.dy, lessThanOrEqualTo(240));
    }
  });

  test('offset layout is used when there is no qr layer', () {
    final layers = <LayerSpec>[
      const LayerSpec.text(
        text: 'Product',
        textStyle: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        offset: Offset(50, -75),
        elementId: 'productName',
      ),
      LayerSpec.widget(
        widget: const SizedBox(width: 240, height: 120),
        kind: LayerKind.barcode,
        offset: const Offset(-68, 45),
        elementId: 'barcode',
      ),
    ];

    final elements = buildTemplateElements(
      width: 416,
      height: 240,
      palette: palette,
      layers: layers,
    );

    expect(elements.length, 2);
    expect(elements.any((e) => e.elementId == 'productName'), isTrue);
    expect(elements.any((e) => e.elementId == 'barcode'), isTrue);
  });

  test('text colors are snapped to the palette', () {
    final layers = <LayerSpec>[
      const LayerSpec.text(
        text: 'Hello',
        textStyle: TextStyle(fontSize: 20),
        textColor: Color(0xFF222222),
        offset: Offset(0, 0),
        elementId: 'name',
      ),
    ];

    final elements = buildTemplateElements(
      width: 416,
      height: 240,
      palette: palette,
      layers: layers,
    );

    expect(palette.contains(elements.first.color), isTrue);
  });
}
