import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/color_util.dart';
import 'package:magicepaperapp/util/epd/custom_display.dart';
import 'package:magicepaperapp/view/image_editor.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';

class CustomDisplayConfigurationScreen extends StatefulWidget {
  const CustomDisplayConfigurationScreen({super.key});

  @override
  State<CustomDisplayConfigurationScreen> createState() =>
      _CustomDisplayConfigurationScreenState();
}

class _CustomDisplayConfigurationScreenState
    extends State<CustomDisplayConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _widthController = TextEditingController(text: '400');
  final _heightController = TextEditingController(text: '300');
  final List<Color> _currentColors = [Colors.white, Colors.black];
  DisplaySdk _selectedSdk = DisplaySdk.fossasia;

  final List<Color> _availableColors = [
    Colors.red,
    Colors.yellow,
    Colors.orange,
    Colors.green,
    Colors.blue,
  ];

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _addColor(AppLocalizations appLocalizations) async {
    final available = _availableColors
        .where((c) => !_currentColors.any((ec) => ec.value == c.value))
        .toList();
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appLocalizations.noMoreColors)));
      return;
    }
    final pickedColor = await showDialog<Color>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(appLocalizations.addColor),
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
    final appLocalizations = AppLocalizations.of(context)!;
    return CommonScaffold(
      index: 0,
      titleWidget: Text(
        appLocalizations.customConfiguration,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(appLocalizations.customScreenSize),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _widthController,
                      decoration: InputDecoration(
                        labelText: appLocalizations.widthLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.width_full),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null ||
                              int.tryParse(v) == null ||
                              int.parse(v) <= 0)
                          ? appLocalizations.invalidValue
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        labelText: appLocalizations.heightLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.height),
                      ),
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
              const SizedBox(height: 32),
              _buildSectionTitle(appLocalizations.displayDriverOrSdk),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    RadioListTile<DisplaySdk>(
                      title: Text(appLocalizations.fossasiaDriver),
                      subtitle: Text(appLocalizations.fossasiaDriverSubtitle),
                      value: DisplaySdk.fossasia,
                      groupValue: _selectedSdk,
                      onChanged: (v) => setState(() => _selectedSdk = v!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    const Divider(height: 1),
                    RadioListTile<DisplaySdk>(
                      title: Text(appLocalizations.waveshareSdk),
                      subtitle: Text(appLocalizations.waveshareSdkSubtitle),
                      value: DisplaySdk.waveshare,
                      groupValue: _selectedSdk,
                      onChanged: (v) => setState(() => _selectedSdk = v!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(appLocalizations.colors),
                  TextButton.icon(
                    onPressed: () => _addColor(appLocalizations),
                    icon: const Icon(Icons.add),
                    label: Text(appLocalizations.addColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _currentColors.map((color) {
                  final isFixed =
                      color == Colors.black || color == Colors.white;
                  return Chip(
                    avatar: CircleAvatar(backgroundColor: color, radius: 10),
                    label: Text(ColorUtils.getColorDisplayName(color)),
                    onDeleted: isFixed ? null : () => _removeColor(color),
                    deleteIconColor: Colors.red,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _submit(appLocalizations),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    appLocalizations.continueButton,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorBlack,
      ),
    );
  }

  void _submit(AppLocalizations appLocalizations) {
    if (_formKey.currentState!.validate()) {
      final customDisplay = CustomDisplayDevice(
        name: appLocalizations.customDisplay,
        modelId: 'CUSTOM',
        width: int.parse(_widthController.text),
        height: int.parse(_heightController.text),
        colors: _currentColors,
        sdk: _selectedSdk,
      );

      getIt<ColorPaletteProvider>().updateColors(customDisplay.colors);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            isExportOnly: false,
            device: customDisplay,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.fixFormErrors)),
      );
    }
  }
}
