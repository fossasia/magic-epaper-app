import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_document.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_element.dart';
import 'package:magicepaperapp/native_canvas/model/stroke.dart';

void main() {
  test('CanvasDocument round-trips text, image, barcode and strokes', () {
    final imageBytes = Uint8List.fromList([1, 2, 3, 4, 5, 250, 255, 0]);

    final doc = CanvasDocument(
      width: 416,
      height: 240,
      canvasColor: const Color(0xFFFFFFFF),
      elements: [
        CanvasElement(
          id: 'el_0',
          kind: CanvasElementKind.text,
          position: const Offset(10, 20),
          baseSize: const Size(100, 40),
          scale: 1.5,
          rotation: 0.25,
          color: const Color(0xFF112233),
          text: 'Hello',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.left,
          fontFamily: 'Lato',
          followCanvasTheme: false,
          elementId: 'title',
        ),
        CanvasElement(
          id: 'el_1',
          kind: CanvasElementKind.image,
          position: const Offset(50, 60),
          baseSize: const Size(80, 80),
          imageBytes: imageBytes,
        ),
        CanvasElement(
          id: 'el_2',
          kind: CanvasElementKind.barcode,
          position: const Offset(200, 120),
          baseSize: const Size(90, 90),
          barcode: Barcode.qrCode(),
          barcodeData: 'https://example.com',
        ),
      ],
      strokes: [
        Stroke(
          points: const [Offset(0, 0), Offset(5, 5), Offset(9, 2)],
          color: const Color(0xFF000000),
          width: 4,
        ),
      ],
    );

    final restored = CanvasDocument.fromJson(doc.toJson());

    expect(restored.width, 416);
    expect(restored.height, 240);
    expect(restored.canvasColor.toARGB32(), 0xFFFFFFFF);
    expect(restored.elements.length, 3);
    expect(restored.strokes.length, 1);

    final text = restored.elements[0];
    expect(text.kind, CanvasElementKind.text);
    expect(text.text, 'Hello');
    expect(text.fontSize, 32);
    expect(text.fontWeight, FontWeight.w700);
    expect(text.textAlign, TextAlign.left);
    expect(text.fontFamily, 'Lato');
    expect(text.scale, 1.5);
    expect(text.rotation, 0.25);
    expect(text.color.toARGB32(), 0xFF112233);
    expect(text.followCanvasTheme, false);
    expect(text.elementId, 'title');
    expect(text.position, const Offset(10, 20));

    final image = restored.elements[1];
    expect(image.kind, CanvasElementKind.image);
    expect(image.imageBytes, imageBytes);

    final barcode = restored.elements[2];
    expect(barcode.kind, CanvasElementKind.barcode);
    expect(barcode.barcodeData, 'https://example.com');
    expect(barcode.barcode?.name, Barcode.qrCode().name);

    final stroke = restored.strokes[0];
    expect(stroke.points.length, 3);
    expect(stroke.points[1], const Offset(5, 5));
    expect(stroke.width, 4);
    expect(stroke.color.toARGB32(), 0xFF000000);
  });

  test('CanvasDocument.toJson drops non-serialisable widget elements', () {
    final doc = CanvasDocument(
      width: 100,
      height: 100,
      canvasColor: const Color(0xFF000000),
      elements: [
        const CanvasElement(
          id: 'el_0',
          kind: CanvasElementKind.widget,
          position: Offset.zero,
          baseSize: Size(10, 10),
          child: SizedBox(),
        ),
      ],
      strokes: const [],
    );

    final restored = CanvasDocument.fromJson(doc.toJson());
    expect(restored.elements, isEmpty);
  });
}
