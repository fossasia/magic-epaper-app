import 'package:flutter/material.dart';

import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/string_constants.dart';

import 'package:magicepaperapp/ndef_screen/app_nfc/app_data_model.dart';
import 'package:magicepaperapp/ndef_screen/app_nfc/app_selection_service.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class AppLauncherCard extends StatefulWidget {
  final AppData? selectedApp;
  final Function(AppData?) onAppSelected;
  final bool isWriting;
  final VoidCallback onWriteAppLauncher;

  const AppLauncherCard({
    super.key,
    required this.selectedApp,
    required this.onAppSelected,
    required this.isWriting,
    required this.onWriteAppLauncher,
  });

  @override
  State<AppLauncherCard> createState() => _AppLauncherCardState();
}

class _AppLauncherCardState extends State<AppLauncherCard> {
  List<AppData> _allApps = [];
  List<AppData> _filteredApps = [];
  bool _isLoading = true;
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customPackageController =
      TextEditingController();
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customPackageController.dispose();
    super.dispose();
  }

  Future<void> _loadApps() async {
    setState(() => _isLoading = true);
    try {
      final apps = await AppLauncherService.getInstalledApps();
      setState(() {
        _allApps = apps;
        _filteredApps = apps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${appLocalizations.errorLoadingApps}$e')),
        );
      }
    }
  }

  void _filterApps(String query) {
    setState(() {
      _filteredApps = AppLauncherService.searchApps(_allApps, query);
    });
  }

  void _addCustomApp() {
    final packageName = _customPackageController.text.trim();
    if (packageName.isEmpty) return;
    if (!AppLauncherService.isValidPackageName(packageName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.invalidPackageName)),
      );
      return;
    }

    final customApp = AppData(
      appName: 'Custom: $packageName',
      packageName: packageName,
    );
    widget.onAppSelected(customApp);
    _customPackageController.clear();
    setState(() => _showCustomInput = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.apps, color: colorAccent, size: 22),
                    SizedBox(width: 8),
                    Text(
                      appLocalizations.writeAppLauncherData,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBlack,
                      ),
                    ),
                  ],

                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorWhite,
                    boxShadow: [
                      BoxShadow(
                        color: colorBlack.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: colorAccent,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
              ],
            ),
            if (widget.selectedApp != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.green.shade300.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    _buildAppIcon(widget.selectedApp!),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectedApp!.appName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.selectedApp!.packageName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorWhite,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.clear,
                            color: Colors.grey, size: 18),
                        onPressed: () => widget.onAppSelected(null),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                onPressed: !widget.isWriting ? widget.onWriteAppLauncher : null,
                icon: widget.isWriting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(colorWhite),
                        ),
                      )
                    : const Icon(Icons.nfc, color: colorWhite),
                label: widget.isWriting
                    ? appLocalizations.writing
                    : appLocalizations.writeAppLauncher,
              ),
            ],
            if (_isExpanded) ...[
              const SizedBox(height: 20),
              _buildSearchSection(),
              const SizedBox(height: 16),
              _buildAppsList(),
            ],
            if (widget.selectedApp == null && !_isExpanded) ...[
              const SizedBox(height: 16),
              _buildSelectButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: mdGrey400.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: _searchController,
            hintText: appLocalizations.searchApps,
            prefixIcon: Icons.search,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add, color: colorAccent, size: 20),
              onPressed: () =>
                  setState(() => _showCustomInput = !_showCustomInput),
              tooltip: appLocalizations.customPackageName,
            ),
            onChanged: _filterApps,
          ),
          if (_showCustomInput) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _customPackageController,
                    hintText: appLocalizations.enterPackageName,
                    prefixIcon: Icons.code,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCustomApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAccent,
                    foregroundColor: colorWhite,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    appLocalizations.add,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppsList() {
    if (_isLoading) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mdGrey400.withValues(alpha: 0.2)),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorAccent),
                strokeWidth: 2,
              ),
              SizedBox(height: 12),
              Text(
                'Loading apps...',
                style: TextStyle(
                  color: colorBlack,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredApps.isEmpty) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mdGrey400.withValues(alpha: 0.2)),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, color: Colors.grey, size: 48),
              SizedBox(height: 8),
              Text(
                appLocalizations.noAppsFound,
                style: TextStyle(
                  color: colorBlack,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: mdGrey400.withValues(alpha: 0.2)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredApps.length,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final app = _filteredApps[index];
          final isSelected = widget.selectedApp?.packageName == app.packageName;

          return Container(
            decoration: BoxDecoration(
              color:
                  isSelected ? colorAccent.withValues(alpha: 0.1) : colorWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? colorAccent.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              leading: _buildAppIcon(app),
              title: Text(
                app.appName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isSelected ? colorAccent : colorBlack,
                ),
              ),
              subtitle: Text(
                app.packageName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              trailing: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      color: colorAccent,
                      size: 20,
                    )
                  : null,
              onTap: () {
                widget.onAppSelected(app);
                setState(() => _isExpanded = false);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppIcon(AppData app) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: app.icon != null
            ? Image.memory(
                app.icon!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackIcon();
                },
              )
            : _buildFallbackIcon(),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.android,
        color: colorAccent,
        size: 24,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: colorAccent, size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mdGrey400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: mdGrey400.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: colorAccent, width: 2),
        ),
        filled: true,
        fillColor: colorWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: colorAccent,
          foregroundColor: colorWhite,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => setState(() => _isExpanded = true),
        icon: const Icon(Icons.apps, color: colorAccent),
        label: const Text(
          appLocalizations.selectApplication,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorAccent,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: colorAccent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
