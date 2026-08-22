import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import 'package:magicepaperapp/command_console/console_interpreter.dart';
import 'package:magicepaperapp/command_console/console_nfc_service.dart';
import 'package:magicepaperapp/command_console/models/console_line.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_status_card.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

class CommandConsoleScreen extends StatefulWidget {
  const CommandConsoleScreen({super.key});

  @override
  State<CommandConsoleScreen> createState() => _CommandConsoleScreenState();
}

class _CommandConsoleScreenState extends State<CommandConsoleScreen>
    with WidgetsBindingObserver {
  final ConsoleNfcService _service = ConsoleNfcService();
  final ConsoleInterpreter _interpreter = ConsoleInterpreter();
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final FocusNode _inputFocus = FocusNode();
  final List<ConsoleLine> _lines = [];
  final List<String> _history = [];

  NFCAvailability _availability = NFCAvailability.not_supported;
  bool _busy = false;

  AppLocalizations get _l10n => getIt.get<AppLocalizations>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _append(const ConsoleLine.system('Magic ePaper command console.'));
    _append(const ConsoleLine.system("Type 'help' for commands."));
    _refreshAvailability();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_service.isConnected) {
      _service.disconnect();
    }
    _input.dispose();
    _scroll.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAvailability();
    }
  }

  Future<void> _refreshAvailability() async {
    final availability = await _service.availability();
    if (mounted) {
      setState(() => _availability = availability);
    }
  }

  void _append(ConsoleLine line) {
    setState(() => _lines.add(line));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _submit() async {
    final text = _input.text;
    if (text.trim().isEmpty || _busy) return;
    _input.clear();
    _history.add(text.trim());
    _inputFocus.requestFocus();
    await _run(text);
  }

  Future<void> _run(String text) async {
    final command = _interpreter.parse(text);
    if (command.type == ConsoleCommandType.empty) return;

    _append(ConsoleLine.input('> ${command.raw}'));

    if (command.error != null &&
        command.type != ConsoleCommandType.transceive &&
        command.type != ConsoleCommandType.readBlock) {
      _append(ConsoleLine.error(command.error!));
      return;
    }

    switch (command.type) {
      case ConsoleCommandType.help:
        for (final line in ConsoleInterpreter.helpText) {
          _append(ConsoleLine.output(line));
        }
        break;
      case ConsoleCommandType.clear:
        setState(() => _lines.clear());
        break;
      case ConsoleCommandType.connect:
        await _connect();
        break;
      case ConsoleCommandType.disconnect:
        await _disconnect();
        break;
      case ConsoleCommandType.info:
        _printTagInfo();
        break;
      case ConsoleCommandType.transceive:
        await _transceive(command);
        break;
      case ConsoleCommandType.readBlock:
        await _readBlock(command);
        break;
      case ConsoleCommandType.unknown:
        _append(ConsoleLine.error(command.error ?? 'Unknown command.'));
        break;
      case ConsoleCommandType.empty:
        break;
    }
  }

  Future<void> _connect() async {
    if (_service.isConnected) {
      _append(
          const ConsoleLine.info('Already connected. Run disconnect first.'));
      return;
    }
    if (_availability != NFCAvailability.available) {
      _append(const ConsoleLine.error('NFC is not available or disabled.'));
      return;
    }
    _append(const ConsoleLine.info('Waiting for tag… tap a badge now.'));
    await _guard(() async {
      await _service.connect();
      _append(const ConsoleLine.output('Tag connected.'));
      _printTagInfo();
    }, 'Connect failed');
    if (mounted) setState(() {});
  }

  Future<void> _disconnect() async {
    if (!_service.isConnected) {
      _append(const ConsoleLine.info('No tag connected.'));
      return;
    }
    await _service.disconnect();
    _append(const ConsoleLine.system('Session closed.'));
    if (mounted) setState(() {});
  }

  Future<void> _transceive(ParsedCommand command) async {
    if (command.error != null) {
      _append(ConsoleLine.error(command.error!));
      return;
    }
    if (!_service.isConnected) {
      _append(const ConsoleLine.error('Not connected. Run connect first.'));
      return;
    }
    await _guard(() async {
      final response = await _service.transceive(command.bytes!);
      _append(
          ConsoleLine.output('< ${ConsoleInterpreter.formatHex(response)}'));
    }, 'Transceive failed');
  }

  Future<void> _readBlock(ParsedCommand command) async {
    if (command.error != null) {
      _append(ConsoleLine.error(command.error!));
      return;
    }
    if (!_service.isConnected) {
      _append(const ConsoleLine.error('Not connected. Run connect first.'));
      return;
    }
    await _guard(() async {
      final response = await _service.readBlock(command.blockNumber!);
      _append(ConsoleLine.output(
          'block ${command.blockNumber}: ${ConsoleInterpreter.formatHex(response)}'));
    }, 'Read block failed');
  }

  Future<void> _guard(
      Future<void> Function() action, String errorPrefix) async {
    setState(() => _busy = true);
    try {
      await action();
    } on PlatformException catch (e) {
      _append(ConsoleLine.error('$errorPrefix: ${e.message ?? e.code}'));
    } catch (e) {
      _append(ConsoleLine.error('$errorPrefix: $e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _printTagInfo() {
    final tag = _service.tag;
    if (tag == null) {
      _append(const ConsoleLine.error('No tag connected.'));
      return;
    }
    _append(ConsoleLine.output('type: ${tag.type.name}'));
    _append(ConsoleLine.output('standard: ${tag.standard}'));
    _append(ConsoleLine.output('id: ${tag.id.toUpperCase()}'));
    _addIfPresent('atqa', tag.atqa);
    _addIfPresent('sak', tag.sak);
    _addIfPresent('historicalBytes', tag.historicalBytes);
    _addIfPresent('protocolInfo', tag.protocolInfo);
    _addIfPresent('applicationData', tag.applicationData);
    _addIfPresent('hiLayerResponse', tag.hiLayerResponse);
    _addIfPresent('manufacturer', tag.manufacturer);
    _addIfPresent('systemCode', tag.systemCode);
    _addIfPresent('dsfId', tag.dsfId);
  }

  void _addIfPresent(String label, String? value) {
    if (value != null && value.isNotEmpty) {
      _append(ConsoleLine.output('$label: ${value.toUpperCase()}'));
    }
  }

  Color _colorFor(ConsoleLineType type) {
    switch (type) {
      case ConsoleLineType.input:
        return const Color(0xFF7FD4FF);
      case ConsoleLineType.output:
        return const Color(0xFFD4D4D4);
      case ConsoleLineType.error:
        return const Color(0xFFFF6B6B);
      case ConsoleLineType.info:
        return const Color(0xFFFFD479);
      case ConsoleLineType.system:
        return const Color(0xFF7FB77E);
    }
  }

  void _showGuide() {
    const commands = <List<String>>[
      ['connect', 'Poll and hold a tag session.'],
      ['disconnect', 'End the tag session.'],
      ['info', 'Print connected tag details (type, id, sak…).'],
      ['tx <hex>', 'Send raw bytes to the tag, print the response.'],
      ['<hex>', 'Shorthand for tx (bare hex is sent as-is).'],
      ['readblock <n>', 'ISO15693 read of a single block n (0-255).'],
      ['help', 'Print the command list in the console.'],
      ['clear', 'Clear the console.'],
    ];
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusL),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimens.spacingL),
                  decoration: const BoxDecoration(
                    color: colorAccent,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Dimens.radiusL),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.terminal, color: colorWhite, size: 22),
                      const SizedBox(width: Dimens.spacingS),
                      Text(
                        _l10n.commandGuide,
                        style: const TextStyle(
                          color: colorWhite,
                          fontSize: Dimens.fontSizeL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Dimens.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _l10n.commandGuideIntro,
                          style: const TextStyle(
                            fontSize: Dimens.fontSizeM,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        for (final entry in commands)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: Dimens.spacingM),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.spacingS,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: grey100,
                                    borderRadius:
                                        BorderRadius.circular(Dimens.radiusS),
                                    border: Border.all(color: grey300),
                                  ),
                                  child: Text(
                                    entry[0],
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimens.fontSizeS,
                                      color: grey900,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: Dimens.spacingM),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      entry[1],
                                      style: const TextStyle(
                                        fontSize: Dimens.fontSizeS,
                                        height: 1.35,
                                        color: grey700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(Dimens.spacingM),
                          decoration: BoxDecoration(
                            color: grey50,
                            borderRadius: BorderRadius.circular(Dimens.radiusM),
                            border: Border.all(color: grey200),
                          ),
                          child: Text(
                            _l10n.commandGuideHexNote,
                            style: const TextStyle(
                              fontSize: Dimens.fontSizeS,
                              height: 1.35,
                              color: grey600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Dimens.spacingS,
                    0,
                    Dimens.spacingS,
                    Dimens.spacingS,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(_l10n.gotIt),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final connected = _service.isConnected;
    return CommonScaffold(
      title: _l10n.commandConsole,
      index: 9,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: colorWhite),
          tooltip: _l10n.commandGuide,
          onPressed: _showGuide,
        ),
      ],
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: Dimens.spacingS),
            NFCStatusCard(
              availability: _availability,
              onRefresh: _refreshAvailability,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacingL,
                vertical: Dimens.spacingS,
              ),
              child: Row(
                children: [
                  Icon(
                    connected ? Icons.link : Icons.link_off,
                    size: Dimens.iconSizeM,
                    color: connected ? Colors.green : grey600,
                  ),
                  const SizedBox(width: Dimens.spacingS),
                  Expanded(
                    child: Text(
                      connected
                          ? '${_l10n.tagConnected}: ${_service.tag?.type.name ?? ''}'
                          : _l10n.noTagConnected,
                      style: const TextStyle(fontSize: Dimens.fontSizeM),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed:
                        _busy ? null : (connected ? _disconnect : _connect),
                    icon: Icon(connected ? Icons.stop : Icons.nfc, size: 18),
                    label:
                        Text(connected ? _l10n.disconnect : _l10n.connectTag),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: connected ? Colors.red : colorAccent,
                      foregroundColor: colorWhite,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildTerminal()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminal() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: Dimens.spacingS),
      padding: const EdgeInsets.all(Dimens.spacingM),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(Dimens.radiusL),
      ),
      child: ListView.builder(
        controller: _scroll,
        itemCount: _lines.length,
        itemBuilder: (context, index) {
          final line = _lines[index];
          final selectable = line.type == ConsoleLineType.input;
          return GestureDetector(
            onTap: selectable
                ? () {
                    final command = line.text.replaceFirst('> ', '');
                    _input.text = command;
                    _input.selection =
                        TextSelection.collapsed(offset: command.length);
                    _inputFocus.requestFocus();
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: SelectableText(
                line.text,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: Dimens.fontSizeS,
                  height: 1.35,
                  color: _colorFor(line.type),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        Dimens.spacingS,
        Dimens.spacingS,
        Dimens.spacingS,
        Dimens.spacingM,
      ),
      child: Row(
        children: [
          const Text(
            '>',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: Dimens.fontSizeL,
              fontWeight: FontWeight.bold,
              color: colorAccent,
            ),
          ),
          const SizedBox(width: Dimens.spacingS),
          Expanded(
            child: TextField(
              controller: _input,
              focusNode: _inputFocus,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _submit(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: Dimens.fontSizeM,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: _l10n.enterCommandHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusM),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingM,
                  vertical: Dimens.spacingMd,
                ),
              ),
            ),
          ),
          const SizedBox(width: Dimens.spacingS),
          IconButton(
            onPressed: _busy ? null : _submit,
            icon: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send, color: colorAccent),
            tooltip: _l10n.run,
          ),
        ],
      ),
    );
  }
}
