import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';
import 'package:magic_epaper_app/provider/getitlocator.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03bw.dart';
import 'package:magic_epaper_app/view/image_editor.dart';
import 'package:provider/provider.dart';
import 'package:magic_epaper_app/provider/color_palette_provider.dart';
import 'package:magic_epaper_app/view/widget/display_card.dart';

class DisplaySelectionScreen extends StatefulWidget {
  const DisplaySelectionScreen({super.key});

  @override
  State<DisplaySelectionScreen> createState() => _DisplaySelectionScreenState();
}

class _DisplaySelectionScreenState extends State<DisplaySelectionScreen> {
  final List<Epd> displays = [Gdey037z03(), Gdey037z03BW()];
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ColorPaletteProvider>(
        create: (_) => getIt<ColorPaletteProvider>(),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: colorAccent,
              elevation: 0,
              title: const Padding(
                padding: EdgeInsets.fromLTRB(5, 16, 16, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(StringConstants.appName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    SizedBox(height: 8),
                    Text('Select your ePaper display type',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              toolbarHeight: 85,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 14, 16.0, 16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: displays.length,
                        itemBuilder: (context, index) => DisplayCard(
                          display: displays[index],
                          isSelected: selectedIndex == index,
                          onTap: () => setState(() => selectedIndex = index),
                        ),
                      ),
                    ),
                    _buildContinueButton(context),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildContinueButton(BuildContext context) {
    final isEnabled = selectedIndex != -1;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                context.read<ColorPaletteProvider>().updateColors(
                      displays[selectedIndex].colors,
                    );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageEditor(
                      epd: displays[selectedIndex],
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimary.withAlpha(isEnabled ? 255 : 125),
          foregroundColor: Colors.white.withAlpha(isEnabled ? 255 : 178),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
