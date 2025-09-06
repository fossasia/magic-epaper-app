import 'package:flutter/material.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/gdeq031t10.dart';
import 'package:magicepaperapp/util/epd/gdey037z03.dart';
import 'package:magicepaperapp/util/epd/gdey037z03bw.dart';
import 'package:magicepaperapp/util/epd/waveshare_displays.dart';
import 'package:magicepaperapp/view/image_editor.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';
import 'package:provider/provider.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/view/widget/display_card.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ColorPaletteProvider>(
      create: (_) => getIt<ColorPaletteProvider>(),
      builder: (context, child) {
        return CommonScaffold(
          index: 0,
          toolbarHeight: 85,
          titleWidget: Padding(
            padding: const EdgeInsets.fromLTRB(5, 16, 16, 5),
            child: Column(
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
                const SizedBox(height: 8),
                Text(
                  appLocalizations.selectDisplayType,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: Padding(
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
                  return DisplayCard(
                    key: Key(displays[index].modelId),
                    display: displays[index],
                    isSelected: false,
                    onTap: () {
                      context.read<ColorPaletteProvider>().updateColors(
                            displays[index].colors,
                          );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageEditor(
                            isExportOnly: false,
                            device: displays[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
