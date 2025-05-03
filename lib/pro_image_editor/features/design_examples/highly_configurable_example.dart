// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../../core/mixin/example_helper.dart';

/// The custom design example
class HighlyConfigurableExample extends StatefulWidget {
  /// Creates a new [HighlyConfigurableExample] widget.
  const HighlyConfigurableExample({
    super.key,
    required this.url,
  });

  /// The URL of the image to display.
  final String url;

  @override
  State<HighlyConfigurableExample> createState() =>
      _HighlyConfigurableExampleState();
}

class _HighlyConfigurableExampleState extends State<HighlyConfigurableExample>
    with ExampleHelperState<HighlyConfigurableExample> {
  @override
  Widget build(BuildContext context) {
    return ProImageEditor.network(
      widget.url,
      callbacks: ProImageEditorCallbacks(
        onImageEditingStarted: onImageEditingStarted,
        onImageEditingComplete: onImageEditingComplete,
        onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
        mainEditorCallbacks: MainEditorCallbacks(
          helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
        ),
      ),
      configs: ProImageEditorConfigs(
        designMode: platformDesignMode,
        i18n: const I18n(
          various: I18nVarious(
            loadingDialogMsg: 'Please wait...',
            closeEditorWarningTitle: 'Close Image Editor?',
            closeEditorWarningMessage:
                'Are you sure you want to close the Image Editor? Your changes '
                'will not be saved.',
            closeEditorWarningConfirmBtn: 'OK',
            closeEditorWarningCancelBtn: 'Cancel',
          ),
          paintEditor: I18nPaintEditor(
            bottomNavigationBarText: 'Paint',
            freestyle: 'Freestyle',
            arrow: 'Arrow',
            line: 'Line',
            rectangle: 'Rectangle',
            circle: 'Circle',
            dashLine: 'Dash line',
            lineWidth: 'Line width',
            toggleFill: 'Toggle fill',
            undo: 'Undo',
            redo: 'Redo',
            done: 'Done',
            back: 'Back',
            smallScreenMoreTooltip: 'More',
          ),
          textEditor: I18nTextEditor(
            inputHintText: 'Enter text',
            bottomNavigationBarText: 'Text',
            back: 'Back',
            done: 'Done',
            textAlign: 'Align text',
            backgroundMode: 'Background mode',
            smallScreenMoreTooltip: 'More',
          ),
          cropRotateEditor: I18nCropRotateEditor(
            bottomNavigationBarText: 'Crop/ Rotate',
            rotate: 'Rotate',
            ratio: 'Ratio',
            back: 'Back',
            done: 'Done',
            smallScreenMoreTooltip: 'More',
          ),
          filterEditor: I18nFilterEditor(
            bottomNavigationBarText: 'Filter',
            back: 'Back',
            done: 'Done',
            filters: I18nFilters(
              none: 'No Filter',
              addictiveBlue: 'AddictiveBlue',
              addictiveRed: 'AddictiveRed',
              aden: 'Aden',
              amaro: 'Amaro',
              ashby: 'Ashby',
              brannan: 'Brannan',
              brooklyn: 'Brooklyn',
              charmes: 'Charmes',
              clarendon: 'Clarendon',
              crema: 'Crema',
              dogpatch: 'Dogpatch',
              earlybird: 'Earlybird',
              f1977: '1977',
              gingham: 'Gingham',
              ginza: 'Ginza',
              hefe: 'Hefe',
              helena: 'Helena',
              hudson: 'Hudson',
              inkwell: 'Inkwell',
              juno: 'Juno',
              kelvin: 'Kelvin',
              lark: 'Lark',
              loFi: 'Lo-Fi',
              ludwig: 'Ludwig',
              maven: 'Maven',
              mayfair: 'Mayfair',
              moon: 'Moon',
              nashville: 'Nashville',
              perpetua: 'Perpetua',
              reyes: 'Reyes',
              rise: 'Rise',
              sierra: 'Sierra',
              skyline: 'Skyline',
              slumber: 'Slumber',
              stinson: 'Stinson',
              sutro: 'Sutro',
              toaster: 'Toaster',
              valencia: 'Valencia',
              vesper: 'Vesper',
              walden: 'Walden',
              willow: 'Willow',
              xProII: 'Pro II',
            ),
          ),
          tuneEditor: I18nTuneEditor(
            bottomNavigationBarText: 'Tune',
            back: 'Back',
            done: 'Done',
            brightness: 'Brightness',
            contrast: 'Contrast',
            saturation: 'Saturation',
            exposure: 'Exposure',
            hue: 'Hue',
            temperature: 'Temperature',
            sharpness: 'Sharpness',
            fade: 'Fade',
            luminance: 'Luminance',
            undo: 'Undo',
            redo: 'Redo',
          ),
          blurEditor: I18nBlurEditor(
            bottomNavigationBarText: 'Blur',
            back: 'Back',
            done: 'Done',
          ),
          emojiEditor: I18nEmojiEditor(
            bottomNavigationBarText: 'Emoji',
          ),
          stickerEditor: I18nStickerEditor(
            bottomNavigationBarText: 'I18nStickerEditor',
          ),
          cancel: 'Cancel',
          undo: 'Undo',
          redo: 'Redo',
          done: 'Done',
          remove: 'Remove',
          doneLoadingMsg: 'Changes are being applied',
        ),
        helperLines: const HelperLineConfigs(
          showVerticalLine: true,
          showHorizontalLine: true,
          showRotateLine: true,
          style: HelperLineStyle(
            horizontalColor: Color.fromARGB(255, 15, 196, 60),
            verticalColor: Color.fromARGB(255, 15, 196, 60),
            rotateColor: Color.fromARGB(255, 231, 255, 11),
          ),
        ),
        mainEditor: const MainEditorConfigs(
          style: MainEditorStyle(
            background: Color.fromARGB(255, 255, 169, 169),
            appBarColor: Color.fromARGB(255, 126, 14, 6),
            appBarBackground: Color.fromARGB(255, 255, 211, 77),
            bottomBarBackground: Colors.purple,
            uiOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(66, 60, 65, 41),
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: Color.fromARGB(255, 255, 139, 216),
            ),
          ),
          icons: MainEditorIcons(
            closeEditor: Icons.clear,
            doneIcon: Icons.save_outlined,
            applyChanges: Icons.check_circle_outlined,
            backButton: Icons.arrow_back,
            undoAction: Icons.turn_left_outlined,
            redoAction: Icons.turn_right_outlined,
            removeElementZone: Icons.delete_forever_outlined,
          ),
        ),
        paintEditor: const PaintEditorConfigs(
          enabled: true,
          enableModeFreeStyle: true,
          enableModeArrow: true,
          enableModeLine: true,
          enableModeRect: true,
          enableModeCircle: true,
          enableModeDashLine: true,
          showToggleFillButton: true,
          showLineWidthAdjustmentButton: true,
          isInitiallyFilled: true,
          enableFreeStyleHighPerformanceScaling: true,
          initialPaintMode: PaintMode.freeStyle,
          style: PaintEditorStyle(
            appBarColor: Color(0xFFE1E1E1),
            appBarBackground: Color.fromARGB(255, 20, 99, 189),
            lineWidthBottomSheetBackground: Colors.green,
            background: Color.fromARGB(255, 255, 249, 196),
            bottomBarBackground: Colors.blueGrey,
            bottomBarActiveItemColor: Color.fromARGB(255, 154, 0, 192),
            bottomBarInactiveItemColor: Color.fromARGB(255, 223, 255, 210),
            initialStrokeWidth: 5.0,
            initialColor: Color.fromARGB(255, 8, 170, 49),
          ),
          icons: PaintEditorIcons(
            bottomNavBar: Icons.palette,
            lineWeight: Icons.line_weight_rounded,
            freeStyle: Icons.roundabout_left,
            arrow: Icons.arrow_downward_rounded,
            line: Icons.horizontal_rule,
            fill: Icons.format_color_fill,
            noFill: Icons.format_color_reset,
            rectangle: Icons.crop_free,
            circle: Icons.lens_outlined,
            dashLine: Icons.power_input,
          ),
        ),
        textEditor: TextEditorConfigs(
          enabled: true,
          showTextAlignButton: true,
          showBackgroundModeButton: true,
          initFontSize: 24.0,
          initialTextAlign: TextAlign.center,
          initialBackgroundColorMode: LayerBackgroundMode.background,
          showSelectFontStyleBottomBar: true,
          style: const TextEditorStyle(
            appBarBackground: Color.fromARGB(255, 0, 17, 255),
            appBarColor: Color(0xFFE1E1E1),
            bottomBarBackground: Colors.blueGrey,
            background: Color.fromARGB(155, 255, 194, 252),
            inputHintColor: Color.fromARGB(255, 255, 0, 0),
            inputCursorColor: Color.fromARGB(255, 15, 182, 0),
          ),
          icons: const TextEditorIcons(
            bottomNavBar: Icons.title,
            alignLeft: Icons.align_horizontal_left_rounded,
            alignCenter: Icons.align_horizontal_center_rounded,
            alignRight: Icons.align_horizontal_right_rounded,
            backgroundMode: Icons.dashboard,
            fontScale: Icons.text_increase_rounded,
            resetFontScale: Icons.restore,
          ),
          customTextStyles: [
            GoogleFonts.roboto(),
            GoogleFonts.averiaLibre(),
            GoogleFonts.lato(),
            GoogleFonts.comicNeue(),
            GoogleFonts.actor(),
            GoogleFonts.odorMeanChey(),
            GoogleFonts.nabla(),
          ],
        ),
        cropRotateEditor: const CropRotateEditorConfigs(
          enabled: true,
          showRotateButton: true,
          showAspectRatioButton: true,
          initAspectRatio: 0.0,
          aspectRatios: [
            AspectRatioItem(text: 'Free', value: null),
            AspectRatioItem(text: 'Original', value: 0.0),
            AspectRatioItem(text: '1*1', value: 1.0 / 1.0),
            AspectRatioItem(text: '3*2', value: 3.0 / 2.0),
            AspectRatioItem(text: '2*3', value: 2.0 / 3.0),
            AspectRatioItem(text: '4*3', value: 4.0 / 3.0),
            AspectRatioItem(text: '3*4', value: 3.0 / 4.0),
            AspectRatioItem(text: '16*9', value: 16.0 / 9.0),
            AspectRatioItem(text: '9*16', value: 9.0 / 16.0),
            AspectRatioItem(text: '3*5.5', value: 3.0 / 5.5),
          ],
          style: CropRotateEditorStyle(
            appBarBackground: Color.fromARGB(255, 85, 0, 0),
            appBarColor: Color(0xFFE1E1E1),
            bottomBarBackground: Color.fromARGB(255, 136, 0, 84),
            bottomBarColor: Color.fromARGB(255, 223, 255, 210),
            background: Color.fromARGB(255, 255, 203, 203),
            cropCornerColor: Color.fromARGB(255, 0, 212, 195),
            aspectRatioSheetBackgroundColor: Colors.green,
            aspectRatioSheetForegroundColor: Color.fromARGB(255, 255, 210, 141),
            cropOverlayColor: Colors.orange,
            helperLineColor: Colors.blue,
          ),
          icons: CropRotateEditorIcons(
            bottomNavBar: Icons.crop_free_rounded,
            rotate: Icons.rotate_left,
            aspectRatio: Icons.crop,
            flip: Icons.swap_horiz,
            reset: Icons.reset_tv,
          ),
        ),
        tuneEditor: TuneEditorConfigs(
          enabled: true,
          showLayers: true,
          tuneAdjustmentOptions: [
            const TuneAdjustmentItem(
              id: 'brightness',
              icon: Icons.brightness_4_outlined,
              label: 'Brightness',
              min: -0.5,
              max: 0.5,
              divisions: 200,
              labelMultiplier: 200,
              toMatrix: ColorFilterAddons.brightness,
            ),
            const TuneAdjustmentItem(
              id: 'contrast',
              icon: Icons.contrast,
              label: 'Contrast',
              min: -0.5,
              max: 0.5,
              divisions: 200,
              labelMultiplier: 200,
              toMatrix: ColorFilterAddons.contrast,
            ),
            const TuneAdjustmentItem(
              id: 'saturation',
              icon: Icons.water_drop_outlined,
              label: 'Saturation',
              min: -0.5,
              max: .5,
              divisions: 200,
              labelMultiplier: 200,
              toMatrix: ColorFilterAddons.saturation,
            ),
            const TuneAdjustmentItem(
              id: 'exposure',
              icon: Icons.exposure,
              label: 'Exposure',
              min: -1,
              max: 1,
              divisions: 200,
              toMatrix: ColorFilterAddons.exposure,
            ),
            const TuneAdjustmentItem(
              id: 'hue',
              icon: Icons.color_lens_outlined,
              label: 'Hue',
              min: -0.25,
              max: .25,
              divisions: 400,
              labelMultiplier: 400,
              toMatrix: ColorFilterAddons.hue,
            ),
            TuneAdjustmentItem(
              id: 'temperature',
              icon: Icons.thermostat_outlined,
              label: 'Temperature',
              min: -0.5,
              max: .5,
              divisions: 200,
              labelMultiplier: 200,
              toMatrix: (value) {
                double r = value > 0 ? 1 : 1 + value;
                double b = value < 0 ? 1 : 1 - value;
                return ColorFilterAddons.rgbScale(r, 1, b);
              },
            ),
            const TuneAdjustmentItem(
              id: 'sharpness',
              icon: Icons.shutter_speed,
              label: 'Sharpness',
              min: 0,
              max: 1,
              divisions: 100,
              toMatrix: ColorFilterAddons.sharpness,
            ),
            const TuneAdjustmentItem(
              id: 'luminance',
              icon: Icons.light_mode_outlined,
              label: 'Luminance',
              min: -1,
              max: 1,
              divisions: 200,
              toMatrix: ColorFilterAddons.luminance,
            ),
            const TuneAdjustmentItem(
              id: 'fade',
              icon: Icons.blur_off_outlined,
              label: 'Fade',
              min: -1,
              max: 1,
              divisions: 200,
              toMatrix: ColorFilterAddons.fade,
            ),
          ],
          style: const TuneEditorStyle(
            appBarBackground: Color.fromARGB(255, 160, 34, 160),
            appBarColor: Color(0xFFE1E1E1),
            background: Color.fromARGB(255, 0, 83, 32),
            bottomBarBackground: Color.fromARGB(255, 0, 136, 136),
            bottomBarActiveItemColor: Color.fromARGB(255, 173, 231, 25),
            bottomBarInactiveItemColor: Color.fromARGB(255, 255, 210, 216),
          ),
          icons: const TuneEditorIcons(
            bottomNavBar: Icons.filter_b_and_w_outlined,
          ),
        ),
        filterEditor: FilterEditorConfigs(
          enabled: true,
          filterList: presetFiltersList,
          style: const FilterEditorStyle(
            appBarBackground: Color.fromARGB(255, 82, 0, 82),
            appBarColor: Color(0xFFE1E1E1),
            previewTextColor: Color.fromARGB(255, 255, 0, 0),
            background: Color.fromARGB(255, 83, 78, 0),
          ),
          icons: const FilterEditorIcons(
            bottomNavBar: Icons.tungsten,
          ),
        ),
        blurEditor: const BlurEditorConfigs(
          enabled: true,
          maxBlur: 20.0,
          style: BlurEditorStyle(
            appBarBackgroundColor: Color.fromARGB(255, 56, 0, 0),
            appBarForegroundColor: Color(0xFFE1E1E1),
            background: Color.fromARGB(255, 187, 214, 255),
          ),
          icons: BlurEditorIcons(
            bottomNavBar: Icons.blur_linear_outlined,
          ),
        ),
        emojiEditor: const EmojiEditorConfigs(
          enabled: true,
          initScale: 2.0,
          checkPlatformCompatibility: true,
          style: EmojiEditorStyle(
            bottomActionBarConfig: BottomActionBarConfig(
              buttonIconColor: Colors.blue,
              backgroundColor: Colors.red,
              buttonColor: Colors.amber,
              showBackspaceButton: false,
            ),
            skinToneConfig: SkinToneConfig(
              enabled: true,
              dialogBackgroundColor: Colors.green,
              indicatorColor: Colors.pink,
            ),
            categoryViewConfig: CategoryViewConfig(
              backgroundColor: Colors.amber,
              iconColor: Colors.purple,
            ),
            textStyle: TextStyle(fontFamilyFallback: ['Apple Color Emoji']),
          ),
          icons: EmojiEditorIcons(
            bottomNavBar: Icons.face_4_outlined,
          ),
        ),

        dialogConfigs: const DialogConfigs(
          style: DialogStyle(
            loadingDialog: LoadingDialogStyle(
              textColor: Color.fromARGB(255, 225, 255, 200),
            ),
          ),
        ),

        /// stickerEditor: StickerEditorConfigs(
        ///   style: StickerEditorStyle()
        ///   icons: StickerEditorIcons(
        ///     bottomNavBar: Icons.layers_outlined,
        ///   ),
        /// ),
        heroTag: 'hero',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green.shade800,
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }
}
