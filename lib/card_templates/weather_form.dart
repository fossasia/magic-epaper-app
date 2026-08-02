import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/weather_badge.dart';
import 'package:magicepaperapp/card_templates/weather_card_widget.dart';
import 'package:magicepaperapp/card_templates/weather_model.dart';
import 'package:magicepaperapp/card_templates/weather_recent_cities.dart';
import 'package:magicepaperapp/card_templates/weather_service.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/page_route_util.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class WeatherForm extends StatefulWidget {
  final int width;
  final int height;

  const WeatherForm({super.key, required this.width, required this.height});

  @override
  State<WeatherForm> createState() => _WeatherFormState();
}

class _WeatherFormState extends State<WeatherForm> {
  final WeatherService _service = WeatherService();

  TemperatureUnit _unit = TemperatureUnit.celsius;
  WeatherData? _data;
  bool _isFetching = false;
  bool _isGenerating = false;
  String? _errorText;

  TextEditingController? _cityFieldController;
  GeoResult? _selectedGeo;
  Timer? _debounce;

  final RecentCitiesStore _recentStore = RecentCitiesStore();
  List<GeoResult> _recent = const <GeoResult>[];
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final list = await _recentStore.load();
    if (!mounted) return;
    setState(() => _recent = list);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _service.dispose();
    super.dispose();
  }

  Future<List<GeoResult>> _debouncedSearch(String query) {
    _debounce?.cancel();
    final completer = Completer<List<GeoResult>>();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        completer.complete(await _service.searchCities(query));
      } catch (_) {
        completer.complete(const <GeoResult>[]);
      }
    });
    return completer.future;
  }

  String _errorMessage(String key) {
    switch (key) {
      case 'weatherErrorEmptyCity':
        return appLocalizations.weatherErrorEmptyCity;
      case 'weatherErrorCityNotFound':
        return appLocalizations.weatherErrorCityNotFound;
      case 'weatherErrorNetwork':
        return appLocalizations.weatherErrorNetwork;
      default:
        return appLocalizations.weatherErrorGeneric;
    }
  }

  Future<void> _fetchWeather({GeoResult? preset}) async {
    FocusScope.of(context).unfocus();
    final existing = preset ?? _selectedGeo;
    final city = _cityFieldController?.text.trim() ?? '';
    if (existing == null && city.isEmpty) {
      setState(() => _errorText = appLocalizations.weatherErrorEmptyCity);
      return;
    }

    setState(() {
      _isFetching = true;
      _errorText = null;
    });

    try {
      final geo = existing ?? await _service.geocodeCity(city);
      final data = await _service.fetchByCoordinates(
        latitude: geo.latitude,
        longitude: geo.longitude,
        displayName: geo.displayName,
      );
      if (!mounted) return;
      _selectedGeo = geo;
      _cityFieldController?.text = geo.displayName;
      setState(() {
        _data = data;
        _lastUpdated = DateTime.now();
      });
      final updated = await _recentStore.add(geo);
      if (mounted) setState(() => _recent = updated);
    } on WeatherException catch (e) {
      if (!mounted) return;
      setState(() => _errorText = _errorMessage(e.messageKey));
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorText = appLocalizations.weatherErrorGeneric);
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  Future<void> _clearRecent() async {
    await _recentStore.clear();
    if (!mounted) return;
    setState(() => _recent = const <GeoResult>[]);
  }

  Future<void> _removeRecent(GeoResult city) async {
    final updated = await _recentStore.remove(city);
    if (!mounted) return;
    setState(() => _recent = updated);
  }

  String _formatUpdated(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.hour)}:${two(dt.minute)}';
  }

  void _setUnit(TemperatureUnit unit) {
    if (_unit == unit) return;
    setState(() => _unit = unit);
  }

  void _submitForm() async {
    final data = _data;
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.weatherFetchFirst)),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isGenerating = true);

    try {
      final layers = <LayerSpec>[
        LayerSpec.widget(
          widget: SizedBox(
            width: widget.width.toDouble(),
            height: widget.height.toDouble(),
            child: WeatherBadge(data: data, unit: _unit),
          ),
          kind: LayerKind.generic,
          elementId: 'weatherSnapshot',
        ),
      ];

      final result = await Navigator.of(context).push<Object>(
        buildOpaqueSlideRoute(
          NativeCanvasEditor(
            width: widget.width,
            height: widget.height,
            initialLayers: layers,
          ),
        ),
      );

      if (!mounted) return;
      if (result is Uint8List) {
        Navigator.of(context)
          ..pop()
          ..pop(result);
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: -1,
      showBackButton: true,
      titleWidget: Text(
        appLocalizations.weatherSnapshotTitle,
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
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimens.spacingL),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.weatherPreviewTitle,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacingM),
              WeatherCardWidget(
                data: _data,
                unit: _unit,
                width: widget.width,
                height: widget.height,
              ),
              if (_data != null) ...[
                const SizedBox(height: Dimens.spacingS),
                _buildUpdatedRow(),
              ],
              const SizedBox(height: Dimens.spacingXl),
              const Divider(height: 1, color: grey500),
              const SizedBox(height: Dimens.spacingXl),
              _buildDetailsCard(),
              const SizedBox(height: Dimens.spacingXxl),
              _buildGenerateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      color: colorWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        side: BorderSide(color: grey300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.wb_cloudy_outlined,
                    color: colorAccent, size: Dimens.iconSizeM),
                const SizedBox(width: Dimens.spacingS),
                Text(
                  appLocalizations.weatherDetails,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeXl,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacingSm),
            Text(
              appLocalizations.weatherDetailsSubtitle,
              style: TextStyle(fontSize: 13, color: grey600),
            ),
            const SizedBox(height: Dimens.spacingL),
            _buildCityField(),
            _buildQuickPicks(),
            if (_errorText != null) ...[
              const SizedBox(height: Dimens.spacingS),
              Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: colorPrimary, size: 18),
                  const SizedBox(width: Dimens.spacingS),
                  Expanded(
                    child: Text(
                      _errorText!,
                      style: const TextStyle(color: colorPrimary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: Dimens.spacingL),
            _buildUnitSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdatedRow() {
    final busy = _isFetching || _isGenerating;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.schedule, size: 14, color: grey500),
        const SizedBox(width: Dimens.spacingXs),
        Text(
          appLocalizations
              .weatherUpdatedAt(_formatUpdated(_lastUpdated ?? DateTime.now())),
          style: TextStyle(fontSize: 12, color: grey600),
        ),
        const SizedBox(width: Dimens.spacingS),
        TextButton.icon(
          onPressed:
              busy || _selectedGeo == null ? null : () => _fetchWeather(),
          style: TextButton.styleFrom(
            foregroundColor: colorPrimary,
            padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingS),
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.refresh, size: 16),
          label: Text(
            appLocalizations.weatherRefresh,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPicks() {
    if (_recent.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimens.spacingM),
        Row(
          children: [
            Icon(Icons.history, size: 16, color: grey600),
            const SizedBox(width: Dimens.spacingXs),
            Text(
              appLocalizations.weatherRecent,
              style: TextStyle(
                fontSize: Dimens.fontSizeS,
                fontWeight: FontWeight.w600,
                color: grey600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _isGenerating ? null : _clearRecent,
              style: TextButton.styleFrom(
                foregroundColor: colorPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.spacingS),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                appLocalizations.weatherClearRecent,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.spacingXs),
        Wrap(
          spacing: Dimens.spacingS,
          runSpacing: Dimens.spacingS,
          children: [for (final c in _recent) _cityChip(c)],
        ),
      ],
    );
  }

  Widget _cityChip(GeoResult city) {
    final label = city.displayName.split(',').first.trim();
    final busy = _isFetching || _isGenerating;
    return InputChip(
      avatar: const Icon(Icons.history, size: 16, color: colorAccent),
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: Dimens.fontSizeS,
        fontWeight: FontWeight.w500,
        color: colorBlack,
      ),
      backgroundColor: grey50,
      side: BorderSide(color: grey300),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
      ),
      onPressed: busy ? null : () => _fetchWeather(preset: city),
      deleteIcon: const Icon(Icons.close, size: 16),
      deleteIconColor: grey600,
      onDeleted: _isGenerating ? null : () => _removeRecent(city),
    );
  }

  Widget _buildCityField() {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorPrimary,
          selectionColor: colorPrimary.withValues(alpha: 0.2),
          selectionHandleColor: colorPrimary,
        ),
      ),
      child: Autocomplete<GeoResult>(
        displayStringForOption: (option) => option.displayName,
        optionsBuilder: (value) async {
          final query = value.text.trim();
          if (query.length < 2) return const Iterable<GeoResult>.empty();
          return _debouncedSearch(query);
        },
        onSelected: (option) {
          FocusScope.of(context).unfocus();
          setState(() => _selectedGeo = option);
          _fetchWeather();
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          _cityFieldController = controller;
          return TextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.search,
            onChanged: (v) {
              if (_selectedGeo != null &&
                  v.trim() != _selectedGeo!.displayName) {
                _selectedGeo = null;
              }
            },
            onSubmitted: (_) => _fetchWeather(),
            cursorColor: colorPrimary,
            style: const TextStyle(
              fontSize: Dimens.fontSizeL,
              color: colorBlack,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: appLocalizations.weatherCityLabel,
              hintText: appLocalizations.weatherCityHint,
              prefixIcon: const Icon(Icons.location_city,
                  color: colorAccent, size: Dimens.iconSizeM),
              suffixIcon: _isFetching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(colorPrimary),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.search, color: colorAccent),
                      onPressed: _isGenerating ? null : () => _fetchWeather(),
                    ),
              labelStyle: TextStyle(
                color: colorBlack.withValues(alpha: 0.7),
                fontSize: Dimens.fontSizeM,
                fontWeight: FontWeight.w500,
              ),
              floatingLabelStyle: const TextStyle(
                color: colorPrimary,
                fontSize: Dimens.fontSizeM,
                fontWeight: FontWeight.w600,
              ),
              hintStyle: TextStyle(
                color: grey500,
                fontSize: Dimens.fontSizeM,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusM),
                borderSide: BorderSide(color: grey300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusM),
                borderSide: BorderSide(color: grey300, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusM),
                borderSide: const BorderSide(color: colorPrimary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingL, vertical: 14),
              filled: true,
              fillColor: grey50,
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(Dimens.radiusM),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 240, maxWidth: 360),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.location_on_outlined,
                          color: colorAccent, size: Dimens.iconSizeM),
                      title: Text(
                        option.displayName,
                        style: const TextStyle(
                            fontSize: Dimens.fontSizeM, color: colorBlack),
                      ),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.weatherUnitLabel,
          style: TextStyle(
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w600,
            color: colorBlack.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: Dimens.spacingM),
        Wrap(
          spacing: Dimens.spacingS,
          children: [
            for (final unit in TemperatureUnit.values)
              ChoiceChip(
                label: Text(unit == TemperatureUnit.celsius ? '°C' : '°F'),
                selected: _unit == unit,
                showCheckmark: false,
                onSelected: _isGenerating ? null : (_) => _setUnit(unit),
                selectedColor: colorPrimary,
                labelStyle: TextStyle(
                  color: _unit == unit ? colorWhite : colorBlack,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: grey50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusL),
                  side:
                      BorderSide(color: _unit == unit ? colorPrimary : grey300),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    final enabled = _data != null && !_isGenerating;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: enabled ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimary.withValues(alpha: enabled ? 1.0 : 0.49),
          foregroundColor:
              colorWhite.withValues(alpha: _isGenerating ? 0.7 : 1.0),
          disabledBackgroundColor: colorPrimary.withValues(alpha: 0.4),
          disabledForegroundColor: colorWhite.withValues(alpha: 0.7),
          elevation: enabled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
        ),
        child: _isGenerating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colorWhite),
                    ),
                  ),
                  const SizedBox(width: Dimens.spacingM),
                  Text(
                    appLocalizations.weatherGenerating,
                    style: const TextStyle(
                        fontSize: Dimens.fontSizeL,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wb_sunny_outlined, size: 18),
                  const SizedBox(width: Dimens.spacingS),
                  Text(
                    appLocalizations.weatherGenerate,
                    style: const TextStyle(
                        fontSize: Dimens.fontSizeL,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
