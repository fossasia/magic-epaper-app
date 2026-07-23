import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/bulk/bulk_generation_screen.dart';
import 'package:magicepaperapp/card_templates/bulk/bulk_template.dart';
import 'package:magicepaperapp/card_templates/bulk/csv_parser.dart';
import 'package:magicepaperapp/card_templates/bulk/photo_source.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_element.dart';
import 'package:magicepaperapp/native_canvas/model/card_layout.dart';
import 'package:magicepaperapp/native_canvas/widgets/badge_canvas_view.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class BulkCsvImportScreen extends StatefulWidget {
  const BulkCsvImportScreen({
    super.key,
    required this.template,
    required this.width,
    required this.height,
    this.device,
  });

  final BulkTemplate template;
  final int width;
  final int height;
  final DisplayDevice? device;

  @override
  State<BulkCsvImportScreen> createState() => _BulkCsvImportScreenState();
}

class _BulkCsvImportScreenState extends State<BulkCsvImportScreen> {
  List<String> _headers = const [];
  List<List<String>> _dataRows = const [];
  final Map<String, int> _mapping = {};
  final Set<String> _autoMapped = {};
  final Map<int, File> _rowPhotos = {};
  final Map<int, Map<String, String>> _rowEdits = {};
  final PhotoResolver _resolver = PhotoResolver();
  String? _fileName;
  bool _showMapping = false;

  BulkField? get _photoField {
    for (final f in widget.template.fields) {
      if (f.isPhoto) return f;
    }
    return null;
  }

  late final List<Color> _palette;
  late final Color _canvasColor;

  @override
  void initState() {
    super.initState();
    final colors = getIt<ColorPaletteProvider>().colors;
    _palette = colors.isNotEmpty ? colors : const [colorWhite, colorBlack];
    _canvasColor = _palette.first;
  }

  bool get _hasFile => _headers.isNotEmpty;

  List<BulkField> get _missingRequired => widget.template.fields
      .where((f) => f.required && !_mapping.containsKey(f.key))
      .toList();

  int get _readyCount {
    var count = 0;
    for (var i = 0; i < _dataRows.length; i++) {
      if (_rowMapAt(i).values.any((v) => v.isNotEmpty)) count++;
    }
    return count;
  }

  Map<String, String> _rowMapAt(int index) {
    final map = _rowMap(_dataRows[index]);
    final edits = _rowEdits[index];
    if (edits != null) map.addAll(edits);
    return map;
  }

  // ---------- CSV + photos ----------

  Future<void> _pickCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    String content;
    if (file.bytes != null) {
      content = utf8.decode(file.bytes!, allowMalformed: true);
    } else if (file.path != null) {
      content = await File(file.path!).readAsString();
    } else {
      return;
    }

    final rows = parseCsv(content);
    if (rows.isEmpty) {
      _snack(appLocalizations.bulkNoRows);
      return;
    }
    final headers = rows.first.map((h) => h.trim()).toList();
    final data = rows.skip(1).toList();

    _mapping.clear();
    _autoMapped.clear();
    _rowPhotos.clear();
    _rowEdits.clear();
    for (final field in widget.template.fields) {
      final col = _autoMatch(field, headers);
      if (col != null) {
        _mapping[field.key] = col;
        _autoMapped.add(field.key);
      }
    }

    setState(() {
      _headers = headers;
      _dataRows = data;
      _fileName = file.name;
      _showMapping = _missingRequired.isNotEmpty;
    });
    _resolvePhotoUrls();
  }

  // Downloads/decodes any photo-column links (http/https or data URIs) into
  // per-row photos. Manually picked photos always win. Runs in the background.
  Future<void> _resolvePhotoUrls() async {
    final field = _photoField;
    if (field == null) return;
    for (final i in _contentRowIndices()) {
      if (_rowPhotos.containsKey(i)) continue;
      final value = _rowMapAt(i)[field.key];
      if (!_resolver.isResolvable(value)) continue;
      final file = await _resolver.resolve(value);
      if (!mounted) return;
      if (file != null) setState(() => _rowPhotos[i] = file);
    }
  }

  int? _autoMatch(BulkField field, List<String> headers) {
    final targets = <String>{
      _norm(field.key),
      _norm(field.label),
      ...field.aliases.map(_norm),
    };
    for (var i = 0; i < headers.length; i++) {
      if (targets.contains(_norm(headers[i]))) return i;
    }
    return null;
  }

  String _norm(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  Future<void> _pickPhotosInOrder() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result == null) return;
    var row = 0;
    for (final f in result.files) {
      if (f.path == null) continue;
      if (row >= _dataRows.length) break;
      _rowPhotos[row] = File(f.path!);
      row++;
    }
    if (mounted) {
      _snack(appLocalizations.bulkPhotosAddedInOrder(row));
      setState(() {});
    }
  }


  Future<void> _downloadSample() async {
    final headers = widget.template.fields.map((f) => f.label).toList();
    final buffer = StringBuffer();
    buffer.writeln(headers.map(_csvCell).join(','));
    for (final row in _indianSampleRows()) {
      final cells = [
        for (final f in widget.template.fields) _csvCell(row[f.key] ?? '')
      ];
      buffer.writeln(cells.join(','));
    }
    try {
      await FileSaver.instance.saveFile(
        name: 'sample_${widget.template.id}',
        bytes: Uint8List.fromList(utf8.encode(buffer.toString())),
        fileExtension: 'csv',
        mimeType: MimeType.csv,
      );
      _snack(appLocalizations.bulkSampleSaved);
    } catch (_) {
      _snack(appLocalizations.bulkSaveFailed);
    }
  }

  String _csvCell(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  List<Map<String, String>> _indianSampleRows() {
    switch (widget.template.id) {
      case 'price_tag':
        return const [
          {'productName': 'Basmati Rice 5kg', 'productDescription': 'India Gate Classic', 'price': '649', 'currency': '₹', 'quantity': '25 in stock', 'barcode': '8901234500017'},
          {'productName': 'Masala Chai 250g', 'productDescription': 'Tata Tea Premium', 'price': '145', 'currency': '₹', 'quantity': '60 in stock', 'barcode': '8901234500024'},
          {'productName': 'Pure Ghee 1L', 'productDescription': 'Amul', 'price': '615', 'currency': '₹', 'quantity': '18 in stock', 'barcode': '8901234500031'},
          {'productName': 'Turmeric Powder 200g', 'productDescription': 'MDH Haldi', 'price': '82', 'currency': '₹', 'quantity': '45 in stock', 'barcode': '8901234500048'},
          {'productName': 'Coconut Oil 500ml', 'productDescription': 'Parachute', 'price': '199', 'currency': '₹', 'quantity': '32 in stock', 'barcode': '8901234500055'},
        ];
      case 'event_badge':
        return const [
          {'eventName': 'DevFest Bengaluru 2026', 'attendeeName': 'Ananya Desai', 'role': 'Speaker', 'organization': 'Google Developer Group', 'ticketId': 'DF-1001', 'qr': 'https://devfest.in/1001'},
          {'eventName': 'DevFest Bengaluru 2026', 'attendeeName': 'Karthik Menon', 'role': 'Attendee', 'organization': 'Zoho', 'ticketId': 'DF-1002', 'qr': 'https://devfest.in/1002'},
          {'eventName': 'DevFest Bengaluru 2026', 'attendeeName': 'Meera Joshi', 'role': 'Volunteer', 'organization': 'GDG Bengaluru', 'ticketId': 'DF-1003', 'qr': 'https://devfest.in/1003'},
          {'eventName': 'DevFest Bengaluru 2026', 'attendeeName': 'Rohan Gupta', 'role': 'Sponsor', 'organization': 'Freshworks', 'ticketId': 'DF-1004', 'qr': 'https://devfest.in/1004'},
          {'eventName': 'DevFest Bengaluru 2026', 'attendeeName': 'Divya Pillai', 'role': 'Organizer', 'organization': 'GDG Bengaluru', 'ticketId': 'DF-1005', 'qr': 'https://devfest.in/1005'},
        ];
      case 'entry_pass_tag':
        return const [
          {'venueName': 'Taj Mahal', 'visitorName': 'Amit Kulkarni', 'passType': 'VIP', 'validDate': '2026-08-15', 'passId': 'TAJ9001', 'qr': 'https://asi.gov.in/9001'},
          {'venueName': 'Taj Mahal', 'visitorName': 'Fatima Khan', 'passType': 'General', 'validDate': '2026-08-15', 'passId': 'TAJ9002', 'qr': 'https://asi.gov.in/9002'},
          {'venueName': 'Red Fort', 'visitorName': 'Suresh Rao', 'passType': 'Student', 'validDate': '2026-08-16', 'passId': 'RF9003', 'qr': 'https://asi.gov.in/9003'},
          {'venueName': 'Gateway of India', 'visitorName': 'Neha Verma', 'passType': 'General', 'validDate': '2026-08-17', 'passId': 'GOI9004', 'qr': 'https://asi.gov.in/9004'},
          {'venueName': 'Mysore Palace', 'visitorName': 'Rajesh Pillai', 'passType': 'VIP', 'validDate': '2026-08-18', 'passId': 'MP9005', 'qr': 'https://asi.gov.in/9005'},
        ];
      case 'employee_id':
      default:
        return const [
          {'companyName': 'Infosys', 'name': 'Rahul Sharma', 'position': 'Software Engineer', 'division': 'Engineering', 'idNumber': 'INF1024', 'qr': 'https://infy.com/1024'},
          {'companyName': 'Tata Consultancy Services', 'name': 'Priya Nair', 'position': 'Project Manager', 'division': 'Delivery', 'idNumber': 'TCS2048', 'qr': 'https://tcs.com/2048'},
          {'companyName': 'Wipro', 'name': 'Arjun Reddy', 'position': 'QA Analyst', 'division': 'Quality Assurance', 'idNumber': 'WIP3072', 'qr': 'https://wipro.com/3072'},
          {'companyName': 'HCLTech', 'name': 'Sneha Iyer', 'position': 'UX Designer', 'division': 'Design', 'idNumber': 'HCL4096', 'qr': 'https://hcltech.com/4096'},
          {'companyName': 'Tech Mahindra', 'name': 'Vikram Singh', 'position': 'DevOps Engineer', 'division': 'Infrastructure', 'idNumber': 'TM5120', 'qr': 'https://techmahindra.com/5120'},
        ];
    }
  }

  // ---------- row helpers / preview ----------

  Map<String, String> _rowMap(List<String> dataRow) {
    final map = <String, String>{};
    for (final field in widget.template.fields) {
      final col = _mapping[field.key];
      if (col != null && col < dataRow.length) {
        map[field.key] = dataRow[col].trim();
      }
    }
    return map;
  }

  List<CanvasElement>? _previewElements() {
    if (_dataRows.isEmpty) return null;
    final rows = _contentRowIndices();
    final index = rows.isEmpty ? 0 : rows.first;
    final row = _rowMapAt(index);
    final photo = _rowPhotos[index];
    final layers =
        widget.template.buildLayers(row, photo, widget.width, widget.height);
    return buildTemplateElements(
      width: widget.width,
      height: widget.height,
      palette: _palette,
      layers: layers,
    );
  }

  String? _sampleValue(String fieldKey) {
    final col = _mapping[fieldKey];
    if (col == null || _dataRows.isEmpty) return null;
    for (final row in _dataRows) {
      if (col < row.length && row[col].trim().isNotEmpty) {
        return row[col].trim();
      }
    }
    return null;
  }

  // ---------- generate ----------

  void _generate() {
    if (_missingRequired.isNotEmpty) {
      setState(() => _showMapping = true);
      _snack(appLocalizations.bulkMapRequired);
      return;
    }
    final rows = <Map<String, String>>[];
    final photos = <File?>[];
    for (var i = 0; i < _dataRows.length; i++) {
      final map = _rowMapAt(i);
      if (map.values.any((v) => v.isNotEmpty)) {
        rows.add(map);
        photos.add(_rowPhotos[i]);
      }
    }
    if (rows.isEmpty) {
      _snack(appLocalizations.bulkNoRows);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BulkGenerationScreen(
          template: widget.template,
          rows: rows,
          photos: photos,
          width: widget.width,
          height: widget.height,
          device: widget.device,
        ),
      ),
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // ---------- build ----------

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: -1,
      showBackButton: true,
      titleWidget: Text(
        appLocalizations.bulkImportTitle,
        style: const TextStyle(
          fontSize: Dimens.fontSizeXxl,
          fontWeight: FontWeight.bold,
          color: colorWhite,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimens.spacingL),
                child: _hasFile ? _buildLoaded() : _buildEmpty(),
              ),
            ),
            if (_hasFile) _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // Before a file is picked.
  Widget _buildEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(widget.template.title),
        const SizedBox(height: Dimens.spacingS),
        Text(
          appLocalizations.bulkUploadHint,
          style: TextStyle(fontSize: Dimens.fontSizeS, color: grey600),
        ),
        const SizedBox(height: Dimens.spacingL),
        _uploadCard(),
        const SizedBox(height: Dimens.spacingM),
        Center(
          child: TextButton.icon(
            onPressed: _downloadSample,
            icon: const Icon(Icons.download_outlined, size: 18),
            label: Text(appLocalizations.bulkDownloadSample),
            style: TextButton.styleFrom(foregroundColor: colorPrimary),
          ),
        ),
        const SizedBox(height: Dimens.spacingM),
        _expectedColumnsCard(),
      ],
    );
  }

  Widget _uploadCard() {
    return InkWell(
      onTap: _pickCsv,
      borderRadius: BorderRadius.circular(Dimens.radiusL),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: Dimens.spacingXxl, horizontal: Dimens.spacingL),
        decoration: BoxDecoration(
          color: colorPrimary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(Dimens.radiusL),
          border: Border.all(
              color: colorPrimary.withValues(alpha: 0.35), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.upload_file, color: colorPrimary, size: 30),
            ),
            const SizedBox(height: Dimens.spacingM),
            Text(
              appLocalizations.bulkSelectCsv,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimens.fontSizeL,
                  color: colorBlack),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expectedColumnsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: colorPrimary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(color: colorPrimary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.bulkExpectedColumns,
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: colorBlack),
          ),
          const SizedBox(height: Dimens.spacingXs),
          Text(
            appLocalizations.bulkNameColumnsHint,
            style: TextStyle(fontSize: Dimens.fontSizeXs, color: grey600),
          ),
          const SizedBox(height: Dimens.spacingM),
          Wrap(
            spacing: Dimens.spacingS,
            runSpacing: Dimens.spacingS,
            children: [
              for (final f in widget.template.fields)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.spacingM, vertical: Dimens.spacingXs),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(Dimens.radiusXl),
                    border: Border.all(color: grey300),
                  ),
                  child: Text(
                    f.required ? '${f.label} *' : f.label,
                    style: TextStyle(
                      fontSize: Dimens.fontSizeS,
                      color: f.required ? colorBlack : grey600,
                      fontWeight:
                          f.required ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // After a file is picked: one page, top to bottom.
  Widget _buildLoaded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fileBar(),
        const SizedBox(height: Dimens.spacingL),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                Icons.badge_outlined,
                appLocalizations.bulkLivePreview,
                subtitle: appLocalizations.bulkFirstRowNote,
              ),
              const SizedBox(height: Dimens.spacingM),
              _previewFrame(),
              const SizedBox(height: Dimens.spacingM),
              _summaryChips(),
            ],
          ),
        ),
        const SizedBox(height: Dimens.spacingL),
        _columnsCard(),
        const SizedBox(height: Dimens.spacingL),
        _recordsCard(),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        border: Border.all(color: grey200),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(IconData icon, String title,
      {String? subtitle, Widget? trailing}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colorPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
          child: Icon(icon, size: 18, color: colorPrimary),
        ),
        const SizedBox(width: Dimens.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: Dimens.fontSizeL,
                  fontWeight: FontWeight.bold,
                  color: colorBlack,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle,
                    style:
                        TextStyle(fontSize: Dimens.fontSizeXs, color: grey600),
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _summaryChips() {
    return Wrap(
      spacing: Dimens.spacingS,
      runSpacing: Dimens.spacingS,
      children: [
        _infoChip(Icons.table_rows_outlined,
            appLocalizations.bulkRowsDetected(_readyCount)),
        if (widget.template.hasPhoto)
          _infoChip(Icons.photo_outlined,
              appLocalizations.bulkPhotosSelected(_rowPhotos.length)),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingM, vertical: Dimens.spacingXs),
      decoration: BoxDecoration(
        color: grey50,
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        border: Border.all(color: grey200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: grey600),
          const SizedBox(width: Dimens.spacingXs),
          Text(
            label,
            style: TextStyle(fontSize: Dimens.fontSizeXs, color: grey700),
          ),
        ],
      ),
    );
  }

  Widget _fileBar() {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingM),
      decoration: BoxDecoration(
        color: grey50,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(color: grey300),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: colorAccent, size: 20),
          const SizedBox(width: Dimens.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fileName ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: colorBlack),
                ),
                Text(
                  appLocalizations.bulkRowsDetected(_dataRows.length),
                  style: TextStyle(fontSize: Dimens.fontSizeXs, color: grey600),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _pickCsv,
            child: Text(appLocalizations.bulkChangeFile,
                style: const TextStyle(color: colorPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _previewFrame() {
    final elements = _previewElements();
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(Dimens.spacingS),
        decoration: BoxDecoration(
          color: grey50,
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          border: Border.all(color: grey200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.radiusS),
          child: AspectRatio(
            aspectRatio: widget.width / widget.height,
            child: elements == null
                ? ColoredBox(
                    color: grey100,
                    child: Center(
                      child: Text(
                        appLocalizations.bulkNoRows,
                        style: TextStyle(color: grey500),
                      ),
                    ),
                  )
                : FittedBox(
                    child: BadgeCanvasView(
                      width: widget.width,
                      height: widget.height,
                      canvasColor: _canvasColor,
                      elements: elements,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _columnsCard() {
    final ok = _missingRequired.isEmpty;
    final matched = _mapping.length;
    final total = widget.template.fields.length;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            Icons.view_column_outlined,
            appLocalizations.bulkMapColumns,
            subtitle: ok
                ? appLocalizations.bulkColumnsAutoMatched
                : appLocalizations.bulkFixColumns,
            trailing: _statusPill(ok, matched, total),
          ),
          if (!ok) ...[
            const SizedBox(height: Dimens.spacingM),
            _inlineNote(
              Icons.error_outline,
              Colors.orange,
              appLocalizations.bulkRequiredMissing(
                  _missingRequired.map((f) => f.label).join(', ')),
            ),
          ],
          const SizedBox(height: Dimens.spacingS),
          const Divider(height: 1),
          InkWell(
            onTap: () => setState(() => _showMapping = !_showMapping),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.spacingM),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _showMapping
                          ? appLocalizations.bulkColumnsAutoMatched
                          : appLocalizations.bulkEditColumns,
                      style: const TextStyle(
                          color: colorPrimary, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(_showMapping ? Icons.expand_less : Icons.expand_more,
                      size: 20, color: colorPrimary),
                ],
              ),
            ),
          ),
          if (_showMapping) ...widget.template.fields.map(_buildFieldCard),
        ],
      ),
    );
  }

  Widget _statusPill(bool ok, int matched, int total) {
    final color = ok ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingM, vertical: Dimens.spacingXs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ok ? Icons.check_circle : Icons.error_outline,
              size: 14, color: color),
          const SizedBox(width: Dimens.spacingXs),
          Text(
            '$matched/$total',
            style: TextStyle(
                fontSize: Dimens.fontSizeXs,
                color: color,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _inlineNote(IconData icon, Color color, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.spacingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimens.radiusM),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: Dimens.spacingS),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: Dimens.fontSizeS, color: grey700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldCard(BulkField field) {
    final mapped = _mapping[field.key];
    final sample = _sampleValue(field.key);
    final auto = _autoMapped.contains(field.key);
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.spacingM),
      padding: const EdgeInsets.all(Dimens.spacingM),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(
          color: (field.required && mapped == null) ? Colors.red : grey300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  field.label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: colorBlack),
                ),
              ),
              if (field.required)
                _tag(appLocalizations.bulkRequired, Colors.red),
              if (auto && mapped != null) ...[
                const SizedBox(width: Dimens.spacingXs),
                _tag(appLocalizations.bulkAutoMatched, colorPrimary),
              ],
            ],
          ),
          const SizedBox(height: Dimens.spacingS),
          DropdownButtonFormField<int?>(
            initialValue: mapped,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: appLocalizations.bulkColumnLabel,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingM, vertical: Dimens.spacingS),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusM),
              ),
            ),
            items: [
              DropdownMenuItem<int?>(
                value: null,
                child: Text(appLocalizations.bulkColumnDontUse,
                    style: TextStyle(color: grey500)),
              ),
              for (var i = 0; i < _headers.length; i++)
                DropdownMenuItem<int?>(
                  value: i,
                  child: Text(
                    _headers[i].isEmpty ? 'Column ${i + 1}' : _headers[i],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (value) {
              setState(() {
                _autoMapped.remove(field.key);
                if (value == null) {
                  _mapping.remove(field.key);
                } else {
                  _mapping[field.key] = value;
                }
              });
              if (field.isPhoto && value != null) _resolvePhotoUrls();
            },
          ),
          if (sample != null) ...[
            const SizedBox(height: Dimens.spacingXs),
            Row(
              children: [
                Icon(Icons.subdirectory_arrow_right, size: 14, color: grey500),
                const SizedBox(width: Dimens.spacingXs),
                Expanded(
                  child: Text(
                    sample,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: Dimens.fontSizeS,
                        color: grey600,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  List<int> _contentRowIndices() {
    final result = <int>[];
    for (var i = 0; i < _dataRows.length; i++) {
      if (_rowMapAt(i).values.any((v) => v.isNotEmpty)) result.add(i);
    }
    return result;
  }

  String _rowName(int index) {
    final value = _rowMapAt(index)[widget.template.nameField.key] ?? '';
    return value.trim().isNotEmpty
        ? value.trim()
        : appLocalizations.bulkCardNumber(index + 1);
  }

  String _recordSubtitle(int index) {
    final map = _rowMapAt(index);
    final nameKey = widget.template.nameField.key;
    final parts = <String>[];
    for (final f in widget.template.fields) {
      if (f.key == nameKey || f.isPhoto) continue;
      final v = map[f.key]?.trim() ?? '';
      if (v.isNotEmpty) parts.add(v);
    }
    return parts.join(' · ');
  }

  Widget _recordsCard() {
    final rows = _contentRowIndices();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            Icons.list_alt_outlined,
            appLocalizations.bulkRecordsTitle,
            subtitle: appLocalizations.bulkRecordsHint,
            trailing: _infoChip(Icons.tag, '${rows.length}'),
          ),
          if (widget.template.hasPhoto) ...[
            const SizedBox(height: Dimens.spacingM),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _pickPhotosInOrder,
                icon: const Icon(Icons.burst_mode_outlined, size: 18),
                label: Text(appLocalizations.bulkAddPhotosInOrder),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorPrimary,
                  side: const BorderSide(color: colorPrimary),
                  padding:
                      const EdgeInsets.symmetric(vertical: Dimens.spacingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radiusM),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: Dimens.spacingS),
          const Divider(height: 1),
          for (final i in rows) _recordTile(i),
        ],
      ),
    );
  }

  Widget _recordTile(int index) {
    final photo = _rowPhotos[index];
    final subtitle = _recordSubtitle(index);
    final hasPhoto = widget.template.hasPhoto;
    return InkWell(
      onTap: () => _editRecord(index),
      borderRadius: BorderRadius.circular(Dimens.radiusM),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.radiusM),
              child: SizedBox(
                width: 44,
                height: 44,
                child: hasPhoto && photo != null
                    ? Image.file(photo, fit: BoxFit.cover)
                    : ColoredBox(
                        color: colorPrimary.withValues(alpha: 0.08),
                        child: Center(
                          child: hasPhoto
                              ? Icon(Icons.add_a_photo_outlined,
                                  size: 18, color: grey500)
                              : Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: colorPrimary),
                                ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: Dimens.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _rowName(index),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: colorBlack, fontWeight: FontWeight.w600),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Dimens.fontSizeXs, color: grey600),
                    ),
                ],
              ),
            ),
            const SizedBox(width: Dimens.spacingS),
            Icon(Icons.edit_outlined, size: 18, color: colorPrimary),
          ],
        ),
      ),
    );
  }

  Future<void> _editRecord(int index) async {
    final base = _rowMapAt(index);
    final controllers = <String, TextEditingController>{
      for (final f in widget.template.fields)
        f.key: TextEditingController(text: base[f.key] ?? ''),
    };
    var photo = _rowPhotos[index];
    Map<String, String>? savedEdits;
    File? savedPhoto;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorWhite,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Dimens.radiusXxl)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                left: Dimens.spacingL,
                right: Dimens.spacingL,
                top: Dimens.spacingL,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom +
                    Dimens.spacingL,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: grey300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimens.spacingL),
                    Text(
                      appLocalizations.bulkEditRecordTitle,
                      style: const TextStyle(
                        fontSize: Dimens.fontSizeXl,
                        fontWeight: FontWeight.bold,
                        color: colorBlack,
                      ),
                    ),
                    const SizedBox(height: Dimens.spacingL),
                    if (widget.template.hasPhoto && _photoField != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimens.radiusM),
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: photo != null
                                  ? Image.file(photo!, fit: BoxFit.cover)
                                  : ColoredBox(
                                      color: grey100,
                                      child: Icon(Icons.person_outline,
                                          color: grey500),
                                    ),
                            ),
                          ),
                          const SizedBox(width: Dimens.spacingM),
                          Expanded(
                            child: TextField(
                              controller: controllers[_photoField!.key],
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                labelText: _photoField!.label,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.radiusM),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimens.spacingS),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              final result = await FilePicker.platform
                                  .pickFiles(type: FileType.image);
                              final path = result?.files.single.path;
                              if (path != null) {
                                setSheet(() {
                                  photo = File(path);
                                  controllers[_photoField!.key]?.clear();
                                });
                              }
                            },
                            icon: const Icon(Icons.attach_file, size: 18),
                            label: Text(appLocalizations.bulkPickFile),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: colorPrimary,
                                side: const BorderSide(color: colorPrimary)),
                          ),
                          if (photo != null)
                            TextButton.icon(
                              onPressed: () => setSheet(() => photo = null),
                              icon: Icon(Icons.close, size: 16, color: grey500),
                              label: Text(appLocalizations.bulkRowChangePhoto,
                                  style: TextStyle(color: grey600)),
                            ),
                        ],
                      ),
                      const SizedBox(height: Dimens.spacingXs),
                      Text(
                        appLocalizations.bulkPhotoLinkHint,
                        style: TextStyle(
                            fontSize: Dimens.fontSizeXs, color: grey600),
                      ),
                      const SizedBox(height: Dimens.spacingL),
                    ],
                    for (final f in widget.template.fields)
                      if (!f.isPhoto) ...[
                      TextField(
                        controller: controllers[f.key],
                        decoration: InputDecoration(
                          labelText: f.label,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimens.radiusM),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimens.spacingM),
                    ],
                    const SizedBox(height: Dimens.spacingS),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.pop(sheetContext);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorBlack,
                              side: BorderSide(color: grey400),
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimens.spacingM),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Dimens.radiusM),
                              ),
                            ),
                            child: Text(appLocalizations.bulkCancel),
                          ),
                        ),
                        const SizedBox(width: Dimens.spacingM),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              savedEdits = {
                                for (final f in widget.template.fields)
                                  f.key: controllers[f.key]!.text,
                              };
                              savedPhoto = photo;
                              Navigator.pop(sheetContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                              foregroundColor: colorWhite,
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimens.spacingM),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Dimens.radiusM),
                              ),
                            ),
                            child: Text(appLocalizations.bulkSaveChanges),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    for (final c in controllers.values) {
      c.dispose();
    }

    if (savedEdits != null && mounted) {
      setState(() {
        _rowEdits[index] = savedEdits!;
        if (savedPhoto != null) {
          _rowPhotos[index] = savedPhoto!;
        } else {
          _rowPhotos.remove(index);
        }
      });
      _resolvePhotoUrls();
    }
  }

  Widget _buildBottomBar() {
    final ready = _missingRequired.isEmpty;
    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacingL),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: ready ? _generate : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
                disabledBackgroundColor: grey300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusL),
                ),
              ),
              icon: const Icon(Icons.auto_awesome_motion, size: 20),
              label: Text(
                appLocalizations.bulkGenerate(_readyCount),
                style: const TextStyle(
                    fontSize: Dimens.fontSizeL, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- shared bits ----------

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: Dimens.fontSizeL,
          fontWeight: FontWeight.bold,
          color: colorBlack,
        ),
      );

  Widget _tag(String text, Color color) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.spacingS, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: Dimens.fontSizeXs,
            color: color,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
