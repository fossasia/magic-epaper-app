class ImageProperties {
  final int fileSizeBytes;
  final int width;
  final int height;
  final String format;
  final double aspectRatio;
  final DateTime lastModified;
  final String filePath;

  ImageProperties({
    required this.fileSizeBytes,
    required this.width,
    required this.height,
    required this.format,
    required this.aspectRatio,
    required this.lastModified,
    required this.filePath,
  });

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024) {
      return '$fileSizeBytes B';
    } else if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get resolution => '${width} × ${height}';

  String get megapixels {
    final mp = (width * height) / 1000000;
    return '${mp.toStringAsFixed(1)} MP';
  }

  String get fileName => filePath.split('/').last;
}
