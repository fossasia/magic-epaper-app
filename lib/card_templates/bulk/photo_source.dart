import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Resolves a photo reference from a CSV cell into a local [File].
///
/// Supported forms (structure for the dynamic-import discussion):
/// - `http://` / `https://` URL  -> downloaded to a temp file
/// - `data:image/...;base64,...` -> decoded to a temp file (embedded photo)
/// - an existing local file path -> used directly
/// Anything else resolves to null so callers fall back to a manually picked
/// photo.
class PhotoResolver {
  PhotoResolver({Duration? timeout})
      : _timeout = timeout ?? const Duration(seconds: 15);

  final Duration _timeout;
  final Map<String, File?> _cache = {};

  Future<File?> resolve(String? value) async {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (_cache.containsKey(v)) return _cache[v];

    File? file;
    if (v.startsWith('data:')) {
      file = await _fromDataUri(v);
    } else if (v.startsWith('http://') || v.startsWith('https://')) {
      file = await _download(v);
    } else if (File(v).existsSync()) {
      file = File(v);
    }
    _cache[v] = file;
    return file;
  }

  bool isResolvable(String? value) {
    final v = value?.trim() ?? '';
    return v.startsWith('data:') ||
        v.startsWith('http://') ||
        v.startsWith('https://') ||
        (v.isNotEmpty && File(v).existsSync());
  }

  Future<File?> _fromDataUri(String uri) async {
    final comma = uri.indexOf(',');
    if (comma < 0) return null;
    final meta = uri.substring(5, comma);
    if (!meta.contains('base64')) return null;
    try {
      final bytes = base64.decode(uri.substring(comma + 1));
      return _writeTemp(bytes, 'embed');
    } catch (_) {
      return null;
    }
  }

  Future<File?> _download(String url) async {
    HttpClient? client;
    try {
      client = HttpClient()..connectionTimeout = _timeout;
      final request = await client.getUrl(Uri.parse(url)).timeout(_timeout);
      final response = await request.close().timeout(_timeout);
      if (response.statusCode != 200) return null;
      final chunks = <int>[];
      await for (final chunk in response) {
        chunks.addAll(chunk);
      }
      return _writeTemp(Uint8List.fromList(chunks), 'url');
    } catch (_) {
      return null;
    } finally {
      client?.close(force: true);
    }
  }

  Future<File> _writeTemp(Uint8List bytes, String tag) async {
    final name =
        'bulk_${tag}_${DateTime.now().microsecondsSinceEpoch}_${bytes.length}.img';
    final file = File('${Directory.systemTemp.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
