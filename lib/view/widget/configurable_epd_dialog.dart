import 'package:flutter/material.dart';
import 'package:magic_epaper_app/util/color_util.dart';

class CustomEpdConfig {
  final int width;
  final int height;
  final List<Color> colors;
  final String presetName;
  CustomEpdConfig({
    required this.width,
    required this.height,
    required this.colors,
    required this.presetName,
  });
}

class DisplayPreset {
  final String name;
  final int width;
  final int height;
  final List<Color> colors;

  DisplayPreset({
    required this.name,
    required this.width,
    required this.height,
    required this.colors,
  });

  static final DisplayPreset custom = DisplayPreset(
    name: 'Custom',
    width: 0,
    height: 0,
    colors: [],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisplayPreset &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class ConfigurableEpdDialog extends StatefulWidget {
  final int initialWidth;
  final int initialHeight;
  final List<Color> initialColors;

  const ConfigurableEpdDialog({
    required this.initialWidth,
    required this.initialHeight,
    required this.initialColors,
    super.key,
  });

  @override
  State<ConfigurableEpdDialog> createState() => _ConfigurableEpdDialogState();
}

class _ConfigurableEpdDialogState extends State<ConfigurableEpdDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late List<Color> _currentColors;
  DisplayPreset? _selectedPreset;
  bool _isCustom = false;

  static final List<DisplayPreset> _presets = [
    DisplayPreset(
        name: 'Waveshare 1.54" B/W/R',
        width: 200,
        height: 200,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 2.13" B/W',
        width: 122,
        height: 250,
        colors: [Colors.white, Colors.black]),
    DisplayPreset(
        name: 'Waveshare 2.13" B/W/R',
        width: 104,
        height: 212,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 2.7" B/W/R',
        width: 176,
        height: 264,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 2.9" B/W/Y',
        width: 128,
        height: 296,
        colors: [Colors.white, Colors.black, Colors.yellow]),
    DisplayPreset(
        name: 'Waveshare 4.2" B/W/R',
        width: 300,
        height: 400,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 5.83" B/W/R',
        width: 480,
        height: 648,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 7.5" B/W/R',
        width: 480,
        height: 800,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 0.97" B/W/R',
        width: 88,
        height: 184,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 1.54" B/W/R/Y',
        width: 152,
        height: 152,
        colors: [Colors.white, Colors.black, Colors.red, Colors.yellow]),
    DisplayPreset(
        name: 'Good Display 2.13" B/W/R',
        width: 122,
        height: 250,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 2.66" B/W/R',
        width: 152,
        height: 296,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 2.7" B/W/R',
        width: 176,
        height: 264,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 2.9" B/W/R',
        width: 128,
        height: 296,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 4.2" B/W/R',
        width: 300,
        height: 400,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 5.83" B/W/Y',
        width: 448,
        height: 600,
        colors: [Colors.white, Colors.black, Colors.yellow]),
    DisplayPreset(
        name: 'Good Display 7.5" B/W/R',
        width: 480,
        height: 800,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 10.2" B/W/R',
        width: 640,
        height: 960,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 12.48" B/W/R',
        width: 984,
        height: 1304,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 13.3" B/W/R',
        width: 680,
        height: 960,
        colors: [Colors.white, Colors.black, Colors.red]),
    DisplayPreset(
        name: 'Good Display 4" Multicolor',
        width: 400,
        height: 600,
        colors: [
          Colors.white,
          Colors.black,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow
        ]),
    DisplayPreset(
        name: 'Good Display 7.3" Spectra',
        width: 480,
        height: 800,
        colors: [
          Colors.white,
          Colors.black,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow
        ]),
    DisplayPreset(
        name: 'Good Display 13.3" Spectra',
        width: 1200,
        height: 1600,
        colors: [
          Colors.white,
          Colors.black,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow
        ]),
    DisplayPreset(
        name: 'Good Display 31.5" E6',
        width: 1440,
        height: 2560,
        colors: [
          Colors.white,
          Colors.black,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow
        ]),
    DisplayPreset.custom,
  ];

  static const List<Color> _availableColors = [
    Colors.red,
    Colors.yellow,
    Colors.orange,
    Colors.green,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    _widthController =
        TextEditingController(text: widget.initialWidth.toString());
    _heightController =
        TextEditingController(text: widget.initialHeight.toString());
    _currentColors = List.from(widget.initialColors);

    _selectedPreset = _presets.firstWhere(
      (p) =>
          p.width == widget.initialWidth &&
          p.height == widget.initialHeight &&
          ColorUtils.colorListsEqual(p.colors, widget.initialColors),
      orElse: () {
        _isCustom = true;
        return DisplayPreset.custom;
      },
    );
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _onPresetChanged(DisplayPreset? preset) {
    if (preset == null) return;
    setState(() {
      _selectedPreset = preset;
      if (preset == DisplayPreset.custom) {
        _isCustom = true;
      } else {
        _isCustom = false;
        _widthController.text = preset.width.toString();
        _heightController.text = preset.height.toString();
        _currentColors = List.from(preset.colors);
      }
    });
  }

  void _addColor() async {
    final available = _availableColors
        .where((c) => !_currentColors.any((ec) => ec.value == c.value))
        .toList();
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No more colors to add.")));
      return;
    }
    final pickedColor = await showDialog<Color>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Select a Color'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: available.length,
                  itemBuilder: (context, index) {
                    final color = available[index];
                    return ListTile(
                      leading: CircleAvatar(backgroundColor: color),
                      title: Text(ColorUtils.getColorDisplayName(color)),
                      onTap: () => Navigator.of(context).pop(color),
                    );
                  },
                ),
              ),
            ));

    if (pickedColor != null) {
      setState(() {
        _currentColors.add(pickedColor);
      });
    }
  }

  void _removeColor(Color color) {
    if (color == Colors.black || color == Colors.white) return;
    setState(() {
      _currentColors.removeWhere((c) => c.value == color.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Your Display'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButtonFormField<DisplayPreset>(
                value: _selectedPreset,
                items: _presets
                    .map((preset) => DropdownMenuItem(
                        value: preset, child: Text(preset.name)))
                    .toList(),
                onChanged: _onPresetChanged,
                decoration: const InputDecoration(labelText: 'Display Preset'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _widthController,
                      readOnly: !_isCustom,
                      decoration: const InputDecoration(labelText: 'Width'),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null ||
                              int.tryParse(v) == null ||
                              int.parse(v) <= 0)
                          ? 'Invalid'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      readOnly: !_isCustom,
                      decoration: const InputDecoration(labelText: 'Height'),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null ||
                              int.tryParse(v) == null ||
                              int.parse(v) <= 0)
                          ? 'Invalid'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Colors:', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _currentColors.map((color) {
                  return Chip(
                    avatar: CircleAvatar(backgroundColor: color, radius: 12),
                    label: Text(ColorUtils.getColorDisplayName(color)),
                    backgroundColor: color.withAlpha(30),
                    onDeleted: (_isCustom &&
                            color != Colors.white &&
                            color != Colors.black)
                        ? () => _removeColor(color)
                        : null,
                    deleteIcon: const Icon(Icons.close, size: 16),
                  );
                }).toList(),
              ),
              if (_isCustom) ...[
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _addColor,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Color"),
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
              ]
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
              Navigator.of(context).pop(
                CustomEpdConfig(
                  width: int.parse(_widthController.text),
                  height: int.parse(_heightController.text),
                  colors: _currentColors,
                  presetName: _selectedPreset?.name ?? 'Custom',
                ),
              );
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
