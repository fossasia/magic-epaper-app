import 'package:magicepaperapp/ndef_screen/app_nfc/app_data_model.dart';

class AppLauncherService {
  static final List<AppData> _commonApps = [
    AppData(appName: 'Chrome', packageName: 'com.android.chrome'),
    AppData(appName: 'Gmail', packageName: 'com.google.android.gm'),
    AppData(appName: 'YouTube', packageName: 'com.google.android.youtube'),
    AppData(appName: 'WhatsApp', packageName: 'com.whatsapp'),
    AppData(appName: 'Instagram', packageName: 'com.instagram.android'),
    AppData(appName: 'Facebook', packageName: 'com.facebook.katana'),
    AppData(appName: 'Twitter', packageName: 'com.twitter.android'),
    AppData(appName: 'Spotify', packageName: 'com.spotify.music'),
    AppData(appName: 'Netflix', packageName: 'com.netflix.mediaclient'),
    AppData(appName: 'Uber', packageName: 'com.ubercab'),
    AppData(appName: 'Maps', packageName: 'com.google.android.apps.maps'),
    AppData(
        appName: 'Calculator', packageName: 'com.google.android.calculator'),
    AppData(appName: 'Settings', packageName: 'com.android.settings'),
  ];

  static List<AppData> getCommonApps() {
    final apps = List<AppData>.from(_commonApps);
    apps.sort((a, b) => a.appName.compareTo(b.appName));
    return apps;
  }

  static AppData createCustomApp(String packageName, {String? customName}) {
    return AppData(
      appName: customName ?? 'Custom: $packageName',
      packageName: packageName,
    );
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

  static List<AppData> searchApps(List<AppData> apps, String query) {
    if (query.isEmpty) return apps;
    final lowercaseQuery = query.toLowerCase();
    return apps
        .where((app) =>
            app.appName.toLowerCase().contains(lowercaseQuery) ||
            app.packageName.toLowerCase().contains(lowercaseQuery))
        .toList();
  }
}
