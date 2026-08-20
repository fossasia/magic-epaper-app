import 'dart:typed_data';

enum ConsoleCommandType {
  empty,
  help,
  connect,
  disconnect,
  info,
  transceive,
  readBlock,
  clear,
  unknown,
}

class ParsedCommand {
  final ConsoleCommandType type;
  final Uint8List? bytes;
  final int? blockNumber;
  final String? error;
  final String raw;

  const ParsedCommand({
    required this.type,
    required this.raw,
    this.bytes,
    this.blockNumber,
    this.error,
  });
}

class ConsoleInterpreter {
  static const List<String> helpText = [
    'Available commands:',
    '  help                 show this list',
    '  connect              poll and hold a tag session',
    '  disconnect           end the tag session',
    '  info                 print connected tag details',
    '  tx <hex>             send raw bytes, print response',
    '  <hex>                shorthand for tx',
    '  readblock <n>        ISO15693 read single block n',
    '  clear                clear the console',
    'Hex is case-insensitive; spaces are ignored (e.g. tx 02 AB 26).',
  ];

  ParsedCommand parse(String input) {
    final raw = input.trim();
    if (raw.isEmpty) {
      return ParsedCommand(type: ConsoleCommandType.empty, raw: raw);
    }

    final parts = raw.split(RegExp(r'\s+'));
    final keyword = parts.first.toLowerCase();
    final rest = parts.skip(1).join(' ');

    switch (keyword) {
      case 'help':
      case '?':
        return ParsedCommand(type: ConsoleCommandType.help, raw: raw);
      case 'connect':
        return ParsedCommand(type: ConsoleCommandType.connect, raw: raw);
      case 'disconnect':
        return ParsedCommand(type: ConsoleCommandType.disconnect, raw: raw);
      case 'info':
        return ParsedCommand(type: ConsoleCommandType.info, raw: raw);
      case 'clear':
      case 'cls':
        return ParsedCommand(type: ConsoleCommandType.clear, raw: raw);
      case 'readblock':
        return _parseReadBlock(rest, raw);
      case 'tx':
      case 'send':
        return _parseHexCommand(rest, raw);
      default:
        if (_looksLikeHex(raw)) {
          return _parseHexCommand(raw, raw);
        }
        return ParsedCommand(
          type: ConsoleCommandType.unknown,
          raw: raw,
          error: "Unknown command '$keyword'. Type 'help' for a list.",
        );
    }
  }

  ParsedCommand _parseReadBlock(String rest, String raw) {
    final block = int.tryParse(rest.trim());
    if (block == null || block < 0 || block > 0xff) {
      return ParsedCommand(
        type: ConsoleCommandType.readBlock,
        raw: raw,
        error: 'readblock needs a block number 0-255, e.g. readblock 0',
      );
    }
    return ParsedCommand(
      type: ConsoleCommandType.readBlock,
      raw: raw,
      blockNumber: block,
    );
  }

  ParsedCommand _parseHexCommand(String hexInput, String raw) {
    try {
      final bytes = parseHex(hexInput);
      if (bytes.isEmpty) {
        return ParsedCommand(
          type: ConsoleCommandType.transceive,
          raw: raw,
          error: 'No bytes to send. Provide hex, e.g. tx 02 26 01 00',
        );
      }
      return ParsedCommand(
        type: ConsoleCommandType.transceive,
        raw: raw,
        bytes: bytes,
      );
    } on FormatException catch (e) {
      return ParsedCommand(
        type: ConsoleCommandType.transceive,
        raw: raw,
        error: e.message,
      );
    }
  }

  static bool _looksLikeHex(String input) {
    return RegExp(r'^[0-9a-fA-F\s]+$').hasMatch(input);
  }

  static Uint8List parseHex(String input) {
    final cleaned = input.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.isEmpty) return Uint8List(0);
    if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(cleaned)) {
      throw const FormatException('Invalid hex: only 0-9 and A-F allowed.');
    }
    if (cleaned.length.isOdd) {
      throw const FormatException('Hex must have an even number of digits.');
    }
    final bytes = Uint8List(cleaned.length ~/ 2);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(cleaned.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return bytes;
  }

  static String formatHex(Uint8List bytes) {
    if (bytes.isEmpty) return '(empty)';
    return bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');
  }
}
