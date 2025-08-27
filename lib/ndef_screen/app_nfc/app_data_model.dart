class AppData {
  final String appName;
  final String packageName;

  AppData({
    required this.appName,
    required this.packageName,
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
