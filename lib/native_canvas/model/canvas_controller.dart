import 'package:flutter/material.dart';

import 'canvas_element.dart';
import 'stroke.dart';

class _CanvasSnapshot {
  final List<CanvasElement> elements;
  final List<Stroke> strokes;
  final Color canvasColor;
  const _CanvasSnapshot(this.elements, this.strokes, this.canvasColor);
}

class CanvasController extends ChangeNotifier {
  CanvasController({
    required this.canvasSize,
    required this.palette,
    Color? canvasColor,
  }) : _canvasColor = canvasColor ??
            (palette.isNotEmpty ? palette.first : Colors.white);

  final Size canvasSize;

  final List<Color> palette;

  final List<CanvasElement> _elements = [];
  List<CanvasElement> get elements => List.unmodifiable(_elements);

  final List<Stroke> _strokes = [];
  List<Stroke> get strokes => List.unmodifiable(_strokes);

  Color _canvasColor;
  Color get canvasColor => _canvasColor;

  String? _selectedId;
  String? get selectedId => _selectedId;
  CanvasElement? get selected => _byId(_selectedId);

  bool get isEmpty => _elements.isEmpty && _strokes.isEmpty;

  final List<_CanvasSnapshot> _undoStack = [];
  final List<_CanvasSnapshot> _redoStack = [];
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  static const int _maxHistory = 60;

  CanvasElement? _byId(String? id) {
    if (id == null) return null;
    for (final e in _elements) {
      if (e.id == id) return e;
    }
    return null;
  }

  void beginChange() {
    _undoStack.add(
      _CanvasSnapshot(List.of(_elements), List.of(_strokes), _canvasColor),
    );
    if (_undoStack.length > _maxHistory) _undoStack.removeAt(0);
    _redoStack.clear();
  }

  void _restore(_CanvasSnapshot snapshot) {
    _elements
      ..clear()
      ..addAll(snapshot.elements);
    _strokes
      ..clear()
      ..addAll(snapshot.strokes);
    _canvasColor = snapshot.canvasColor;
    if (_byId(_selectedId) == null) _selectedId = null;
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(
      _CanvasSnapshot(List.of(_elements), List.of(_strokes), _canvasColor),
    );
    _restore(_undoStack.removeLast());
    notifyListeners();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(
      _CanvasSnapshot(List.of(_elements), List.of(_strokes), _canvasColor),
    );
    _restore(_redoStack.removeLast());
    notifyListeners();
  }

  void startStroke(Stroke stroke) {
    beginChange();
    _selectedId = null;
    _strokes.add(stroke);
    notifyListeners();
  }

  void extendStroke(Offset point) {
    if (_strokes.isEmpty) return;
    _strokes[_strokes.length - 1] = _strokes.last.addPoint(point);
    notifyListeners();
  }

  void eraseAt(Offset point, double radius) {
    bool changed = false;
    final List<Stroke> next = [];
    for (final s in _strokes) {
      final threshold = radius + s.width / 2;
      final hits = s.points.any((p) => (p - point).distance <= threshold);
      if (!hits) {
        next.add(s);
        continue;
      }
      changed = true;
      List<Offset> segment = [];
      for (final p in s.points) {
        if ((p - point).distance <= threshold) {
          if (segment.isNotEmpty) {
            next.add(Stroke(points: segment, color: s.color, width: s.width));
            segment = [];
          }
        } else {
          segment.add(p);
        }
      }
      if (segment.isNotEmpty) {
        next.add(Stroke(points: segment, color: s.color, width: s.width));
      }
    }
    if (changed) {
      _strokes
        ..clear()
        ..addAll(next);
      notifyListeners();
    }
  }

  void select(String? id) {
    if (_selectedId == id) return;
    _selectedId = id;
    notifyListeners();
  }

  void addElement(CanvasElement element, {bool record = true}) {
    if (record) beginChange();
    _elements.add(element);
    _selectedId = element.id;
    notifyListeners();
  }

  void updateElement(CanvasElement element) {
    final index = _elements.indexWhere((e) => e.id == element.id);
    if (index == -1) return;
    _elements[index] = element;
    notifyListeners();
  }

  void removeById(String id) {
    if (_byId(id) == null) return;
    beginChange();
    _elements.removeWhere((e) => e.id == id);
    if (_selectedId == id) _selectedId = null;
    notifyListeners();
  }

  void bringToFront(String id) {
    final element = _byId(id);
    if (element == null || _elements.last.id == id) return;
    beginChange();
    _elements
      ..remove(element)
      ..add(element);
    notifyListeners();
  }

  Color contrastColor(Color background) {
    Color best = palette.isNotEmpty ? palette.first : Colors.black;
    double bestDiff = -1;
    for (final c in palette) {
      final diff = (c.computeLuminance() - background.computeLuminance()).abs();
      if (diff > bestDiff) {
        bestDiff = diff;
        best = c;
      }
    }
    return best;
  }

  void _applyCanvasThemeToText() {
    final ink = contrastColor(_canvasColor);
    for (var i = 0; i < _elements.length; i++) {
      final e = _elements[i];
      if (e.kind == CanvasElementKind.text && e.followCanvasTheme) {
        _elements[i] = e.copyWith(color: ink);
      }
    }
  }

  void setCanvasColor(Color color) {
    if (_canvasColor.toARGB32() == color.toARGB32()) return;
    beginChange();
    _canvasColor = color;
    _applyCanvasThemeToText();
    notifyListeners();
  }

  void cycleCanvasColor() {
    if (palette.isEmpty) return;
    final current = palette.indexWhere(
      (c) => c.toARGB32() == _canvasColor.toARGB32(),
    );
    setCanvasColor(palette[(current + 1) % palette.length]);
  }
}
