import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/util/color_util.dart';
import 'package:magicepaperapp/util/epd/custom_display.dart';
import 'package:magicepaperapp/view/image_editor.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:path_provider/path_provider.dart';

class CustomDisplayConfigurationScreen extends StatefulWidget {
  const CustomDisplayConfigurationScreen({super.key});

  @override
  State<CustomDisplayConfigurationScreen> createState() =>
      _CustomDisplayConfigurationScreenState();
}

class _CustomDisplayConfigurationScreenState
    extends State<CustomDisplayConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'My Custom...');
  final _widthCtrl = TextEditingController(text: '400');
  final _heightCtrl = TextEditingController(text: '300');

  List<Color> _selectedColors = [Colors.white, Colors.black];
  DriverIC _selectedDriver = DriverIC.uc8253;

  List<DynamicDisplay> _savedConfigs = [];
  bool _isLoading = true;

  final List<Color> _colorBank = [
    Colors.red,
    Colors.yellow,
    Colors.orange,
    Colors.green,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedConfigs();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  Future<File> _getStorageFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/custom_displays.json');
  }

  Future<void> _loadSavedConfigs() async {
    try {
      final file = await _getStorageFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(content);
        if (!mounted) return;
        setState(() {
          _savedConfigs =
              jsonList.map((j) => DynamicDisplay.fromJson(j)).toList();
        });
      }
    } catch (e) {
      debugPrint("Storage load error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConfig(DynamicDisplay config) async {
    setState(() => _savedConfigs.add(config));
    await _persistConfigs();
  }

  Future<void> _deleteConfig(int index) async {
    setState(() => _savedConfigs.removeAt(index));
    await _persistConfigs();
  }

  Future<void> _persistConfigs() async {
    try {
      final file = await _getStorageFile();
      final jsonList = _savedConfigs.map((c) => c.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      debugPrint("Storage save error: $e");
    }
  }

  void _pickColor() async {
    final available =
        _colorBank.where((c) => !_selectedColors.contains(c)).toList();
    if (available.isEmpty) return;

    final picked = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Palette Color',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: available
              .map((color) => InkWell(
                    onTap: () => Navigator.pop(context, color),
                    child: CircleAvatar(
                        backgroundColor: color,
                        radius: 24,
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20)),
                  ))
              .toList(),
        ),
      ),
    );

    if (picked != null && mounted) {
      setState(() => _selectedColors.add(picked));
    }
  }

  void _openEditor(DynamicDisplay device) {
    try {
      getIt<ColorPaletteProvider>().updateColors(device.colors);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              _LoadingWrapper(
            child: ImageEditor(isExportOnly: false, device: device),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    } catch (e) {
      debugPrint("Navigation pipeline crash: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Custom',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: colorAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: _buildConfigurationForm())),
                    Container(width: 1, color: Colors.grey.shade300),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                              child: Text('Saved Profiles',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: colorBlack))),
                          Expanded(
                              child: _buildSavedConfigsList(isMobile: false)),
                        ],
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildConfigurationForm(),
                      const SizedBox(height: 40),
                      const Divider(thickness: 1),
                      const SizedBox(height: 24),
                      const Text('Saved',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: colorBlack)),
                      const SizedBox(height: 16),
                      _buildSavedConfigsList(isMobile: true),
                    ],
                  ),
                ),
    );
  }

  Widget _buildConfigurationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Compatible with ST25DV NFC chip hardware only.',
              style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
          const SizedBox(height: 24),
          const Text('Profile Name',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(height: 8),
          _buildTextField(_nameCtrl, 'e.g. My Custom 2.9 Inch', isText: true),
          const SizedBox(height: 24),
          const Text('Display Driver IC (Controller)',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<DriverIC>(
            initialValue: _selectedDriver,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
            ),
            items: const [
              DropdownMenuItem(
                  value: DriverIC.uc8253,
                  child: Text('UltraChip UC8253 (Default)')),
              DropdownMenuItem(
                  value: DriverIC.ssd1680,
                  child: Text('Solomon Systech SSD1680')),
              DropdownMenuItem(
                  value: DriverIC.ssd1681,
                  child: Text('Solomon Systech SSD1681')),
              DropdownMenuItem(
                  value: DriverIC.uc8151d, child: Text('UltraChip UC8151D')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedDriver = val);
              }
            },
          ),
          const SizedBox(height: 24),
          const Text('Resolution Dimensions (px)',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildTextField(_widthCtrl, 'Width')),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField(_heightCtrl, 'Height')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Color Palette Options',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey)),
              IconButton(
                  onPressed: _pickColor,
                  icon: const Icon(Icons.add_circle, color: colorAccent),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints())
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedColors.map((color) {
              final isBase = color == Colors.black || color == Colors.white;
              return Chip(
                backgroundColor: color,
                label: Text(ColorUtils.getColorDisplayName(color),
                    style: TextStyle(
                        color:
                            color == Colors.white ? Colors.black : Colors.white,
                        fontSize: 12)),
                deleteIcon: isBase
                    ? null
                    : const Icon(Icons.cancel, size: 18, color: Colors.white70),
                onDeleted: isBase
                    ? null
                    : () => setState(() => _selectedColors.remove(color)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                side: BorderSide(color: Colors.grey.shade300),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade700),
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final config = DynamicDisplay(
                        name: _nameCtrl.text.trim().isEmpty
                            ? 'Custom Layout'
                            : _nameCtrl.text.trim(),
                        width: int.parse(_widthCtrl.text),
                        height: int.parse(_heightCtrl.text),
                        colors: List.unmodifiable(_selectedColors),
                        icType: _selectedDriver,
                      );
                      _saveConfig(config);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Configuration saved safely.')));
                    }
                  },
                  child: const Text('Save',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final config = DynamicDisplay(
                        name: _nameCtrl.text.trim().isEmpty
                            ? 'Custom Layout'
                            : _nameCtrl.text.trim(),
                        width: int.parse(_widthCtrl.text),
                        height: int.parse(_heightCtrl.text),
                        colors: List.unmodifiable(_selectedColors),
                        icType: _selectedDriver,
                      );
                      _openEditor(config);
                    }
                  },
                  child: const Text('Open Editor',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavedConfigsList({required bool isMobile}) {
    if (_savedConfigs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)),
        child: const Text('Nothing saved yet.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      shrinkWrap: isMobile,
      physics: isMobile
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(16),
      itemCount: _savedConfigs.length,
      itemBuilder: (context, index) {
        final config = _savedConfigs[index];

        String driverLabel;
        switch (config.icType) {
          case DriverIC.ssd1680:
            driverLabel = 'SSD1680';
            break;
          case DriverIC.ssd1681:
            driverLabel = 'SSD1681';
            break;
          case DriverIC.uc8151d:
            driverLabel = 'UC8151D';
            break;
          case DriverIC.uc8253:
            driverLabel = 'UC8253';
            break;
        }

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300)),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(config.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
                Text('${config.width}x${config.height}px • IC: $driverLabel'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon:
                        Icon(Icons.delete_outline, color: Colors.red.shade700),
                    onPressed: () => _deleteConfig(index)),
                IconButton(
                    icon: const Icon(Icons.edit_square, color: colorAccent),
                    onPressed: () => _openEditor(config)),
              ],
            ),
            onTap: () {
              setState(() {
                _nameCtrl.text = config.name;
                _widthCtrl.text = config.width.toString();
                _heightCtrl.text = config.height.toString();
                _selectedColors = List.from(config.colors);
                _selectedDriver = config.icType;
              });
              if (isMobile) {
                Scrollable.ensureVisible(_formKey.currentContext!,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint,
      {bool isText = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isText ? TextInputType.text : TextInputType.number,
      textAlign: isText ? TextAlign.start : TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
      validator: (v) {
        if (isText) return v == null || v.trim().isEmpty ? 'Required' : null;
        return (v == null || int.tryParse(v) == null || int.parse(v) <= 0)
            ? '!'
            : null;
      },
    );
  }
}

class _LoadingWrapper extends StatefulWidget {
  final Widget child;
  const _LoadingWrapper({required this.child});
  @override
  State<_LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<_LoadingWrapper> {
  bool _showLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() => _showLoading = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)))),
      );
    }
    return widget.child;
  }
}
