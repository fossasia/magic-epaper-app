import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:magicepaperapp/ndef_screen/app_nfc/app_data_model.dart';

class AppLauncherService {
  static List<AppData> _cachedApps = [];

  static Future<List<AppData>> getInstalledApps(
      {bool includeIcons = true}) async {
    if (_cachedApps.isNotEmpty) {
      return _cachedApps;
    }
    try {
      final List<AppInfo> apps = await InstalledApps.getInstalledApps(
        true,
        includeIcons,
        "",
      );

      _cachedApps = apps
          .where((app) => app.packageName.isNotEmpty && app.name.isNotEmpty)
          .map((app) => AppData(
                appName: app.name,
                packageName: app.packageName,
                icon: app.icon,
              ))
          .toList();

      _cachedApps.sort((a, b) => a.appName.compareTo(b.appName));
      return _cachedApps;
    } catch (e) {
      debugPrint('Error getting installed apps: $e');
    }
    return [];
  }

  static List<AppData> searchApps(List<AppData> apps, String query) {
    if (query.isEmpty) return apps;
    final lowercaseQuery = query.toLowerCase();
    return apps
        .where((app) =>
            app.appName.toLowerCase().contains(lowercaseQuery) ||
            app.packageName.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  static bool isValidPackageName(String packageName) {
    if (packageName.isEmpty ||
        !packageName.contains('.') ||
        packageName.startsWith('.') ||
        packageName.endsWith('.') ||
        packageName.contains('..')) {
      return false;
    }
    return packageName.split('.').every((segment) =>
        segment.isNotEmpty &&
        RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(segment));
  }
}
