import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/color_util.dart';
import 'package:magicepaperapp/util/epd/display_presets.dart';
import 'package:magicepaperapp/theme/colors.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

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

  static final List<DisplayPreset> _presets = displayPresets;

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
        .where(
            (c) => !_currentColors.any((ec) => ec.toARGB32() == c.toARGB32()))
        .toList();
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appLocalizations.noMoreColorsToAdd)));
      return;
    }
    final pickedColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appLocalizations.selectAColor),
        content: SizedBox(
          width: 350,
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
      ),
    );

    if (pickedColor != null) {
      if (!mounted) return;
      setState(() {
        _currentColors.add(pickedColor);
      });
    }
  }

  void _removeColor(Color color) {
    if (color == colorBlack || color == colorWhite) return;
    setState(() {
      _currentColors.removeWhere((c) => c.toARGB32() == color.toARGB32());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(appLocalizations.chooseYourDisplay),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButtonFormField<DisplayPreset>(
                initialValue: _selectedPreset,
                items: _presets
                    .map((preset) => DropdownMenuItem(
                        value: preset,
                        child: Text(
                          preset == DisplayPreset.custom
                              ? appLocalizations.customPreset
                              : preset.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )))
                    .toList(),
                onChanged: _onPresetChanged,
                decoration:
                    InputDecoration(labelText: appLocalizations.displayPreset),
                isExpanded: true,
              ),
              const SizedBox(height: Dimens.spacingL),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _widthController,
                      readOnly: !_isCustom,
                      decoration: InputDecoration(
                          labelText: appLocalizations.widthLabel),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null ||
                              int.tryParse(v) == null ||
                              int.parse(v) <= 0)
                          ? appLocalizations.invalidValue
                          : null,
                    ),
                  ),
                  const SizedBox(width: Dimens.spacingM),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      readOnly: !_isCustom,
                      decoration: InputDecoration(
                          labelText: appLocalizations.heightLabel),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null ||
                              int.tryParse(v) == null ||
                              int.parse(v) <= 0)
                          ? appLocalizations.invalidValue
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimens.spacingL),
              Text(appLocalizations.colorsLabel,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: Dimens.spacingS),
              Wrap(
                spacing: Dimens.spacingS,
                runSpacing: Dimens.spacingXs,
                children: _currentColors.map((color) {
                  return Chip(
                    avatar: CircleAvatar(backgroundColor: color, radius: 12),
                    label: Text(
                      ColorUtils.getColorDisplayName(color),
                      overflow: TextOverflow.ellipsis,
                    ),
                    backgroundColor: color.withAlpha(30),
                    onDeleted: (_isCustom &&
                            color != colorWhite &&
                            color != colorBlack)
                        ? () => _removeColor(color)
                        : null,
                    deleteIcon: const Icon(Icons.close, size: Dimens.iconSizeS),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.spacingXxs),
          child: Wrap(
            spacing: Dimens.spacingS,
            runSpacing: Dimens.spacingXs,
            alignment: WrapAlignment.spaceBetween,
            children: [
              if (_isCustom)
                ElevatedButton.icon(
                  onPressed: _addColor,
                  icon: const Icon(Icons.add, size: Dimens.iconSizeS),
                  label: Text(appLocalizations.addColor),
                ),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(appLocalizations.cancel),
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
                child: Text(appLocalizations.ok),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
