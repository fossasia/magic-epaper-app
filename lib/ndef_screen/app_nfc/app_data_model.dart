import 'dart:typed_data';

class AppData {
  final String appName;
  final String packageName;
  final Uint8List? icon;

  AppData({
    required this.appName,
    required this.packageName,
    this.icon,
  });

  @override
  String toString() => appName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppData &&
          runtimeType == other.runtimeType &&
          packageName == other.packageName;

  @override
  int get hashCode => packageName.hashCode;
}
