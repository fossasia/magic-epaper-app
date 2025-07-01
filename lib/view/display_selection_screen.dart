import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';
import 'package:magic_epaper_app/provider/getitlocator.dart';
import 'package:magic_epaper_app/util/epd/configurable_editor.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03bw.dart';
import 'package:magic_epaper_app/view/image_editor.dart';
import 'package:provider/provider.dart';
import 'package:magic_epaper_app/provider/color_palette_provider.dart';
import 'package:magic_epaper_app/view/widget/display_card.dart';

class DisplaySelectionScreen extends StatefulWidget {
  const DisplaySelectionScreen({super.key});

  @override
  State<DisplaySelectionScreen> createState() => _DisplaySelectionScreenState();
}

class _DisplaySelectionScreenState extends State<DisplaySelectionScreen> {
  final List<Epd> displays = [
    Gdey037z03(),
    Gdey037z03BW(),
    ConfigurableEpd(
        width: 240,
        height: 416,
        colors: [Colors.white, Colors.black, Colors.red]),
  ];
  int selectedIndex = -1;

  void _showConfigurableDialog() async {
    final configurable = displays.last as ConfigurableEpd;
    final result = await showDialog<_CustomEpdConfig>(
      context: context,
      builder: (context) => _CustomEpdDialog(
        initialWidth: configurable.width,
        initialHeight: configurable.height,
        initialColors: List<Color>.from(configurable.colors),
      ),
    );
    if (result != null) {
      setState(() {
        displays[displays.length - 1] = ConfigurableEpd(
          width: result.width,
          height: result.height,
          colors: result.colors,
          name: 'Custom Export',
        );
        selectedIndex = displays.length - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ColorPaletteProvider>(
        create: (_) => getIt<ColorPaletteProvider>(),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: colorAccent,
              elevation: 0,
              title: const Padding(
                padding: EdgeInsets.fromLTRB(5, 16, 16, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(StringConstants.appName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    SizedBox(height: 8),
                    Text('Select your ePaper display type',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              toolbarHeight: 85,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 14, 16.0, 16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: displays.length,
                        itemBuilder: (context, index) {
                          return DisplayCard(
                            display: displays[index],
                            isSelected: selectedIndex == index,
                            onTap: () {
                              if (index == displays.length - 1) {
                                _showConfigurableDialog();
                              } else {
                                setState(() => selectedIndex = index);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    _buildContinueButton(context),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildContinueButton(BuildContext context) {
    final isEnabled = selectedIndex != -1;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                context.read<ColorPaletteProvider>().updateColors(
                      displays[selectedIndex].colors,
                    );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageEditor(
                      epd: displays[selectedIndex],
                      isExportOnly: displays[selectedIndex] is ConfigurableEpd,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimary.withAlpha(isEnabled ? 255 : 125),
          foregroundColor: Colors.white.withAlpha(isEnabled ? 255 : 178),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Custom EPD dialog and config class
class _CustomEpdConfig {
  final int width;
  final int height;
  final List<Color> colors;
  _CustomEpdConfig(
      {required this.width, required this.height, required this.colors});
}

class _CustomEpdDialog extends StatefulWidget {
  final int initialWidth;
  final int initialHeight;
  final List<Color> initialColors;
  const _CustomEpdDialog({
    this.initialWidth = 240,
    this.initialHeight = 416,
    this.initialColors = const [Colors.white, Colors.black],
  });
  @override
  State<_CustomEpdDialog> createState() => _CustomEpdDialogState();
}

class _CustomEpdDialogState extends State<_CustomEpdDialog> {
  final _formKey = GlobalKey<FormState>();
  late int width;
  late int height;
  late List<Color> colors;

  static const List<_ColorChoice> availableColorChoices = [
    _ColorChoice(color: Colors.red, label: 'Red'),
    _ColorChoice(color: Colors.yellow, label: 'Yellow'),
    _ColorChoice(color: Colors.orange, label: 'Orange'),
    _ColorChoice(color: Colors.green, label: 'Green'),
    _ColorChoice(color: Colors.blue, label: 'Blue'),
  ];

  static const List<_ColorChoice> fixedColorChoices = [
    _ColorChoice(color: Colors.white, label: 'White'),
    _ColorChoice(color: Colors.black, label: 'Black'),
  ];

  @override
  void initState() {
    super.initState();
    width = widget.initialWidth;
    height = widget.initialHeight;
    // Always start with white and black, then any valid extra colors
    colors = [Colors.white, Colors.black];
    for (final c in widget.initialColors.skip(2)) {
      if (availableColorChoices
          .any((choice) => choice.color.value == c.value)) {
        colors.add(c);
      }
    }
  }

  void _addColor() async {
    // Show dialog to pick from available colors not already selected
    final usedColors = colors.map((c) => c.value).toSet();
    final choices = availableColorChoices
        .where((c) => !usedColors.contains(c.color.value))
        .toList();
    if (choices.isEmpty) return;
    final picked = await showDialog<_ColorChoice>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: choices
              .map((choice) => ListTile(
                    leading: CircleAvatar(backgroundColor: choice.color),
                    title: Text(choice.label),
                    onTap: () => Navigator.of(context).pop(choice),
                  ))
              .toList(),
        ),
      ),
    );
    if (picked != null) {
      setState(() {
        colors.add(picked.color);
      });
    }
  }

  void _removeColor(int index) {
    if (index >= 2 && colors.length > 2) {
      setState(() {
        colors.removeAt(index);
      });
    }
  }

  String _getColorLabel(Color color) {
    if (color.value == Colors.white.value) return 'White';
    if (color.value == Colors.black.value) return 'Black';
    final found = availableColorChoices.firstWhere(
      (c) => c.color.value == color.value,
      orElse: () => _ColorChoice(color: color, label: 'Color'),
    );
    return found.label;
  }

  @override
  Widget build(BuildContext context) {
    final canAddColor = colors.length - 2 < availableColorChoices.length;
    return AlertDialog(
      title: const Text('Configure Custom Display'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: width.toString(),
                      decoration: const InputDecoration(labelText: 'Width'),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null ||
                              int.tryParse(v) == null ||
                              int.parse(v) <= 0)
                          ? 'Enter valid width'
                          : null,
                      onSaved: (v) => width = int.parse(v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: height.toString(),
                      decoration: const InputDecoration(labelText: 'Height'),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null ||
                              int.tryParse(v) == null ||
                              int.parse(v) <= 0)
                          ? 'Enter valid height'
                          : null,
                      onSaved: (v) => height = int.parse(v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Colors:',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: List.generate(colors.length, (i) {
                  final color = colors[i];
                  final label = _getColorLabel(color);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: color,
                        radius: 16,
                        child: i >= 2 ? null : null,
                      ),
                      const SizedBox(height: 2),
                      Text(label, style: const TextStyle(fontSize: 12)),
                      if (i >= 2)
                        IconButton(
                          icon: const Icon(Icons.delete, size: 16),
                          onPressed: () => _removeColor(i),
                          tooltip: 'Remove',
                        ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 8),
              if (canAddColor)
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Color'),
                    onPressed: _addColor,
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(_CustomEpdConfig(
                  width: width, height: height, colors: List.from(colors)));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _ColorChoice {
  final Color color;
  final String label;
  const _ColorChoice({required this.color, required this.label});
}
