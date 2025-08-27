import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/string_constants.dart';
import 'package:magicepaperapp/ndef_screen/app_nfc/app_data_model.dart';
import 'package:magicepaperapp/ndef_screen/app_nfc/app_selection_service.dart';

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
          SnackBar(content: Text('Error loading apps: $e')),
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
        const SnackBar(content: Text(StringConstants.invalidPackageName)),
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
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.apps, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    StringConstants.writeAppLauncherData,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon:
                      Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                ),
              ],
            ),
            if (widget.selectedApp != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectedApp!.appName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.selectedApp!.packageName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => widget.onAppSelected(null),
                    ),
                  ],
                ),
              ),
            ],
            if (widget.selectedApp != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      !widget.isWriting ? widget.onWriteAppLauncher : null,
                  icon: widget.isWriting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.nfc),
                  label: Text(
                    widget.isWriting
                        ? 'Writing...'
                        : StringConstants.writeAppLauncher,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: StringConstants.searchApps,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () =>
                        setState(() => _showCustomInput = !_showCustomInput),
                    tooltip: StringConstants.customPackageName,
                  ),
                  border: const OutlineInputBorder(),
                ),
                onChanged: _filterApps,
              ),
              if (_showCustomInput) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customPackageController,
                        decoration: const InputDecoration(
                          hintText: StringConstants.enterPackageName,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addCustomApp,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_filteredApps.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(StringConstants.noAppsFound),
                  ),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: _filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = _filteredApps[index];
                      final isSelected =
                          widget.selectedApp?.packageName == app.packageName;

                      return ListTile(
                        leading: const Icon(Icons.android),
                        title: Text(app.appName),
                        subtitle: Text(
                          app.packageName,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        selected: isSelected,
                        onTap: () {
                          widget.onAppSelected(app);
                          setState(() => _isExpanded = false);
                        },
                      );
                    },
                  ),
                ),
            ],
            if (widget.selectedApp == null && !_isExpanded) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _isExpanded = true),
                  icon: const Icon(Icons.apps),
                  label: const Text(StringConstants.selectApplication),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
