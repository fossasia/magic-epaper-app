import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:magicepaperapp/card_templates/calendar_card_widget.dart';
import 'package:magicepaperapp/card_templates/calendar_model.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class CalendarForm extends StatefulWidget {
  final int width;
  final int height;
  final DisplayDevice? device;

  const CalendarForm({
    super.key,
    required this.width,
    required this.height,
    this.device,
  });

  @override
  State<CalendarForm> createState() => _CalendarFormState();
}

class _CalendarFormState extends State<CalendarForm> {
  final GlobalKey _boundaryKey = GlobalKey();
  final DateTime _today = DateTime.now();

  late DateTime _anchor;
  CalendarView _view = CalendarView.month;
  bool _weekStartsMonday = false;
  bool _inverted = false;
  bool _isBusy = false;

  Color? _accent;

  @override
  void initState() {
    super.initState();
    _anchor = DateTime(_today.year, _today.month, _today.day);
    _accent = _accentFrom(getIt<ColorPaletteProvider>().colors);
  }

  Color? _accentFrom(List<Color> palette) {
    for (final color in palette) {
      if (color == colorWhite || color == colorBlack) continue;
      return color;
    }
    return null;
  }

  CalendarModel get _model => CalendarModel(
        anchor: _anchor,
        today: _today,
        weekStartsMonday: _weekStartsMonday,
        view: _view,
      );

  CalendarCardWidget _buildCard() {
    final ink = _inverted ? colorWhite : colorBlack;
    return CalendarCardWidget(
      data: _model,
      ink: ink,
      background: _inverted ? colorBlack : colorWhite,
      highlight: _accent ?? ink,
      dayFooter: _dayFooter(),
    );
  }

  String _dayFooter() {
    final anchorDay = DateTime(_anchor.year, _anchor.month, _anchor.day);
    final todayDay = DateTime(_today.year, _today.month, _today.day);
    final diff = anchorDay.difference(todayDay).inDays;
    if (diff == 0) return appLocalizations.calendarTodayLabel;
    if (diff > 0) return appLocalizations.calendarDaysToGo(diff);
    return appLocalizations.calendarDaysAgo(-diff);
  }

  void _step(int direction) {
    setState(() => _anchor = _model.step(direction));
  }

  void _goToToday() {
    setState(() => _anchor = DateTime(_today.year, _today.month, _today.day));
  }

  void _setView(CalendarView view) {
    setState(() => _view = view);
  }

  Future<void> _jumpToDate() async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _anchor,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: appLocalizations.calendarJumpToDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: colorPrimary,
                  onPrimary: colorWhite,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _anchor = picked);
    }
  }

  Future<Uint8List?> _capture() async {
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 1);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeToBadge() async {
    final device = widget.device;
    if (device == null) {
      await _openInEditor();
      return;
    }
    setState(() => _isBusy = true);
    try {
      final bytes = await _capture();
      if (!mounted || bytes == null) return;
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return;
      await device.transfer(context, decoded);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _openInEditor() async {
    setState(() => _isBusy = true);
    try {
      final bytes = await _capture();
      if (!mounted || bytes == null) return;
      Navigator.of(context)
        ..pop()
        ..pop(bytes);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: -1,
      showBackButton: true,
      titleWidget: Text(
        appLocalizations.calendarCard,
        style: const TextStyle(
          fontSize: Dimens.fontSizeXxl,
          fontWeight: FontWeight.bold,
          color: colorWhite,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          onPressed: _showInfo,
          icon: const Icon(Icons.info_outline, color: colorWhite),
          tooltip: appLocalizations.calendarHowItWorks,
        ),
      ],
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(Dimens.spacingL,
                  Dimens.spacingL, Dimens.spacingL, Dimens.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildViewSelector(),
                  const SizedBox(height: Dimens.spacingL),
                  _buildPreview(),
                  const SizedBox(height: Dimens.spacingL),
                  _buildNavigator(),
                  const SizedBox(height: Dimens.spacingL),
                  _buildOptionsCard(),
                  const SizedBox(height: Dimens.spacingXxl),
                  _buildActions(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Transform.translate(
                offset: const Offset(-100000, 0),
                child: RepaintBoundary(
                  key: _boundaryKey,
                  child: SizedBox(
                    width: widget.width.toDouble(),
                    height: widget.height.toDouble(),
                    child: _buildCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfo() {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(Dimens.spacingXxl),
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(Dimens.radiusXxl),
            boxShadow: [
              BoxShadow(
                color: colorBlack.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(Dimens.spacingM),
                    decoration: BoxDecoration(
                      color: colorAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimens.radiusXl),
                    ),
                    child: const Icon(Icons.calendar_month,
                        color: colorAccent, size: Dimens.iconSizeL),
                  ),
                  const SizedBox(width: Dimens.spacingL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizations.calendarHowItWorks,
                          style: const TextStyle(
                            fontSize: Dimens.fontSizeXxl,
                            fontWeight: FontWeight.bold,
                            color: colorBlack87,
                          ),
                        ),
                        const SizedBox(height: Dimens.spacingXs),
                        Text(
                          appLocalizations.calendarInfoOffline,
                          style: const TextStyle(
                            fontSize: Dimens.fontSizeM,
                            color: grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimens.spacingXl),
              _infoStep(1, appLocalizations.calendarInfoSelect),
              _infoStep(2, appLocalizations.calendarInfoViews),
              _infoStep(3, appLocalizations.calendarInfoWrite),
              const SizedBox(height: Dimens.spacingL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAccent,
                    foregroundColor: colorWhite,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(vertical: Dimens.spacingL),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.radiusXl),
                    ),
                  ),
                  child: Text(
                    appLocalizations.calendarGotIt,
                    style: const TextStyle(
                      fontSize: Dimens.fontSizeL,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: Dimens.fontSizeM,
                fontWeight: FontWeight.bold,
                color: colorAccent,
              ),
            ),
          ),
          const SizedBox(width: Dimens.spacingL),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: Dimens.fontSizeM,
                color: grey800,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final aspect = widget.height == 0 ? 1.0 : widget.width / widget.height;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Container(
          padding: const EdgeInsets.all(Dimens.spacingM),
          decoration: BoxDecoration(
            color: grey100,
            borderRadius: BorderRadius.circular(Dimens.radiusXl),
            border: Border.all(color: grey200),
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: aspect == 0 ? 1.0 : aspect,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(Dimens.radiusS),
                    border: Border.all(color: grey300),
                    boxShadow: [
                      BoxShadow(
                        color: colorBlack.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _buildCard(),
                ),
              ),
              const SizedBox(height: Dimens.spacingS),
              Text(
                '${widget.width} × ${widget.height} px',
                style: TextStyle(
                  fontSize: Dimens.fontSizeXs,
                  color: grey500,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingXxs),
      decoration: BoxDecoration(
        color: grey100,
        borderRadius: BorderRadius.circular(Dimens.radiusRound),
        border: Border.all(color: grey200),
      ),
      child: Row(
        children: [
          _viewTab(CalendarView.month, appLocalizations.calendarViewMonth),
          _viewTab(CalendarView.week, appLocalizations.calendarViewWeek),
          _viewTab(CalendarView.day, appLocalizations.calendarViewDay),
        ],
      ),
    );
  }

  Widget _viewTab(CalendarView view, String label) {
    final selected = _view == view;
    return Expanded(
      child: GestureDetector(
        onTap: _isBusy ? null : () => _setView(view),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? colorPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimens.radiusRound),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colorPrimary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimens.fontSizeM,
              fontWeight: FontWeight.w600,
              color: selected ? colorWhite : grey700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigator() {
    return Card(
      color: colorWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        side: BorderSide(color: grey300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingS, vertical: Dimens.spacingS),
        child: Row(
          children: [
            IconButton(
              onPressed: _isBusy ? null : () => _step(-1),
              icon: const Icon(Icons.chevron_left, color: colorAccent),
              tooltip: appLocalizations.calendarPrevious,
            ),
            Expanded(
              child: InkWell(
                onTap: _isBusy ? null : _jumpToDate,
                borderRadius: BorderRadius.circular(Dimens.radiusM),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimens.spacingS, horizontal: Dimens.spacingXs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _titleLabel(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: Dimens.fontSizeL,
                            fontWeight: FontWeight.bold,
                            color: colorBlack,
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimens.spacingXs),
                      const Icon(Icons.expand_more,
                          color: colorAccent, size: Dimens.iconSizeM),
                    ],
                  ),
                ),
              ),
            ),
            if (!_model.isOnToday)
              TextButton(
                onPressed: _isBusy ? null : _goToToday,
                style: TextButton.styleFrom(
                  foregroundColor: colorPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.spacingS),
                  minimumSize: const Size(0, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(appLocalizations.calendarToday),
              ),
            IconButton(
              onPressed: _isBusy ? null : () => _step(1),
              icon: const Icon(Icons.chevron_right, color: colorAccent),
              tooltip: appLocalizations.calendarNext,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsCard() {
    final showWeekStart = _view != CalendarView.day;
    return Card(
      color: colorWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        side: BorderSide(color: grey300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingL, vertical: Dimens.spacingXs),
        child: Column(
          children: [
            if (showWeekStart) ...[
              _optionRow(
                icon: Icons.view_week_outlined,
                title: appLocalizations.calendarStartMonday,
                subtitle: _weekStartsMonday
                    ? appLocalizations.calendarWeekMonSun
                    : appLocalizations.calendarWeekSunSat,
                value: _weekStartsMonday,
                onChanged: (value) => setState(() => _weekStartsMonday = value),
              ),
              const Divider(height: 1, color: grey200),
            ],
            _optionRow(
              icon: Icons.dark_mode_outlined,
              title: appLocalizations.calendarInvertStyle,
              subtitle: _inverted
                  ? appLocalizations.calendarInvertOn
                  : appLocalizations.calendarInvertOff,
              value: _inverted,
              onChanged: (value) => setState(() => _inverted = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(Dimens.radiusM),
            ),
            child: Icon(icon, color: colorPrimary, size: Dimens.iconSizeM),
          ),
          const SizedBox(width: Dimens.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeM,
                    fontWeight: FontWeight.w600,
                    color: colorBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Dimens.fontSizeXs,
                    color: grey600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: colorPrimary,
            onChanged: _isBusy ? null : onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    final canWrite = widget.device != null;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _isBusy ? null : _writeToBadge,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary.withAlpha(_isBusy ? 125 : 255),
              foregroundColor: colorWhite.withAlpha(_isBusy ? 178 : 255),
              elevation: _isBusy ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusM),
              ),
            ),
            icon: _isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colorWhite),
                    ),
                  )
                : Icon(canWrite ? Icons.nfc : Icons.edit_outlined, size: 18),
            label: Text(
              canWrite
                  ? appLocalizations.calendarWriteToBadge
                  : appLocalizations.calendarOpenInEditor,
              style: const TextStyle(
                fontSize: Dimens.fontSizeL,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (canWrite) ...[
          const SizedBox(height: Dimens.spacingM),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _isBusy ? null : _openInEditor,
              style: OutlinedButton.styleFrom(
                foregroundColor: colorPrimary,
                side: const BorderSide(color: colorPrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusM),
                ),
              ),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(
                appLocalizations.calendarOpenInEditor,
                style: const TextStyle(
                  fontSize: Dimens.fontSizeL,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _titleLabel() {
    final locale = Localizations.maybeLocaleOf(context)?.toString();
    switch (_view) {
      case CalendarView.month:
        return toBeginningOfSentenceCase(
          DateFormat.yMMMM(locale).format(_model.firstOfMonth),
        );
      case CalendarView.week:
        final days = _model.weekDays;
        final start = days.first;
        final end = days.last;
        final startStr = DateFormat.MMMd(locale).format(start);
        if (start.month == end.month) {
          return '$startStr – ${end.day}, ${end.year}';
        }
        return '$startStr – ${DateFormat.MMMd(locale).format(end)}, ${end.year}';
      case CalendarView.day:
        return toBeginningOfSentenceCase(
          DateFormat.yMMMd(locale).format(_anchor),
        );
    }
  }
}
