import 'package:flutter/material.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/gdeq031t10.dart';
import 'package:magicepaperapp/util/epd/gdey037z03.dart';
import 'package:magicepaperapp/util/epd/gdey037z03bw.dart';
import 'package:magicepaperapp/util/epd/waveshare_displays.dart';
import 'package:magicepaperapp/view/image_editor.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';
import 'package:magicepaperapp/view/widget/display_card.dart';
import 'package:provider/provider.dart';

class DisplaySelectionScreen extends StatefulWidget {
  const DisplaySelectionScreen({super.key});

  @override
  State<DisplaySelectionScreen> createState() => _DisplaySelectionScreenState();
}

class _DisplaySelectionScreenState extends State<DisplaySelectionScreen> {
  final List<DisplayDevice> displays = [
    GDEQ031T10(),
    Gdey037z03BW(),
    Gdey037z03(),
    Waveshare2in13(),
    Waveshare2in9(),
    Waveshare2in9b(),
    Waveshare2in7(),
    Waveshare4in2(),
    Waveshare7in5(),
    Waveshare7in5HD(),
  ];

  static const double _scrollbarGutter = 16.0;
  static const double _mobileBreakpoint = 600.0;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildMobileGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 14, 16.0, 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: displays.length,
        itemBuilder: (context, index) {
          return _buildDisplayCard(context, displays[index], null);
        },
      ),
    );
  }

  Widget _buildResponsiveGrid(
      BuildContext context, BoxConstraints constraints) {
    const double horizontalPadding = 16.0;
    const double spacing = 12.0;
    const double targetCardWidth = 340.0;

    final double available =
        constraints.maxWidth - (horizontalPadding * 2) - _scrollbarGutter;
    final int columns = (available / targetCardWidth).floor().clamp(1, 4);
    final double cardWidth = (available - spacing * (columns - 1)) / columns;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          horizontalPadding,
          14.0,
          horizontalPadding + _scrollbarGutter,
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int row = 0; row < displays.length; row += columns)
              Padding(
                padding: const EdgeInsets.only(bottom: spacing),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int col = 0; col < columns; col++) ...[
                        if (col > 0) const SizedBox(width: spacing),
                        Expanded(
                          child: (row + col) < displays.length
                              ? _buildDisplayCard(
                                  context, displays[row + col], cardWidth)
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayCard(
      BuildContext context, DisplayDevice display, double? width) {
    void onTap() {
      context.read<ColorPaletteProvider>().updateColors(display.colors);

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              _LoadingWrapper(
            child: ImageEditor(
              isExportOnly: false,
              device: display,
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }

    final key = Key(display.modelId);

    return width == null
        ? DisplayCard.fill(
            key: key,
            display: display,
            isSelected: false,
            onTap: onTap,
          )
        : DisplayCard.scaled(
            key: key,
            display: display,
            isSelected: false,
            width: width,
            onTap: onTap,
          );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return ChangeNotifierProvider<ColorPaletteProvider>.value(
      value: getIt<ColorPaletteProvider>(),
      builder: (context, child) {
        return CommonScaffold(
          index: 0,
          toolbarHeight: 70,
          leadingUpOffset: 12,
          titleWidget: Builder(
            builder: (context) {
              final double windowWidth = MediaQuery.of(context).size.width;
              final bool showTitle = windowWidth >= 200;
              final bool showSubtitle = windowWidth >= 340;

              if (!showTitle) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(left: 5, right: 16),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations.appName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (showSubtitle) ...[
                        const SizedBox(height: 8),
                        Text(
                          appLocalizations.selectDisplayType,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < _mobileBreakpoint) {
                  return _buildMobileGrid(context);
                }
                return _buildResponsiveGrid(context, constraints);
              },
            ),
          ),
        );
      },
    );
  }
}

class _LoadingWrapper extends StatefulWidget {
  final Widget child;

  const _LoadingWrapper({required this.child});

  @override
  State<_LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<_LoadingWrapper> {
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _showLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)?.loading ?? 'Loading...',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}
