// Dart imports:
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:vibration/vibration.dart';

import '../../features/preview/preview_img.dart';
import '../constants/example_constants.dart';
export '../../shared/widgets/prepare_image_widget.dart';

/// A mixin that provides helper methods and state management for image editing
/// using the [ProImageEditor]. It is intended to be used in a [StatefulWidget].
mixin ExampleHelperState<T extends StatefulWidget> on State<T> {
  /// The global key used to reference the state of [ProImageEditor].
  final editorKey = GlobalKey<ProImageEditorState>();

  /// Holds the edited image bytes after the editing is complete.
  Uint8List? editedBytes;

  /// The time it took to generate the edited image in milliseconds.
  double? _generationTime;

  /// Records the start time of the editing process.
  DateTime? startEditingTime;

  /// Indicates whether image-resources are pre-cached.
  bool isPreCached = true;

  bool _deviceCanVibrate = false;
  bool _deviceCanCustomVibrate = false;

  @override
  void initState() {
    super.initState();

    Vibration.hasVibrator().then((hasVibrator) async {
      _deviceCanVibrate = hasVibrator;

      if (!hasVibrator || !mounted) return;

      _deviceCanCustomVibrate = await Vibration.hasCustomVibrationsSupport();
    });
  }

  /// Determines if the current layout should use desktop mode based on the
  /// screen width.
  ///
  /// Returns `true` if the screen width is greater than or equal to
  /// [kImageEditorExampleIsDesktopBreakPoint], otherwise `false`.
  bool isDesktopMode(BuildContext context) =>
      MediaQuery.sizeOf(context).width >=
      kImageEditorExampleIsDesktopBreakPoint;

  /// Called when the image editing process starts.
  /// Records the time when editing began.
  Future<void> onImageEditingStarted() async {
    startEditingTime = DateTime.now();
  }

  /// Called when the image editing process is complete.
  /// Saves the edited image bytes and calculates the generation time.
  ///
  /// [bytes] is the edited image in bytes.
  Future<void> onImageEditingComplete(Uint8List bytes) async {
    editedBytes = bytes;
    setGenerationTime();
  }

  /// Calculates the time taken for the image generation in milliseconds
  /// and stores it in [_generationTime].
  void setGenerationTime() {
    if (startEditingTime != null) {
      _generationTime = DateTime.now()
          .difference(startEditingTime!)
          .inMilliseconds
          .toDouble();
    }
  }

  /// Closes the image editor and navigates to a preview page showing the
  /// edited image.
  ///
  /// If [showThumbnail] is true, a thumbnail of the image will be displayed.
  /// The [rawOriginalImage] can be passed if the unedited image needs to be
  /// shown.
  /// The [generationConfigs] can be used to pass additional configurations for
  /// generating the image.
  void onCloseEditor({
    required EditorMode editorMode,
    bool enablePop = true,
    bool showThumbnail = false,
    ui.Image? rawOriginalImage,
    final ImageGenerationConfigs? generationConfigs,
  }) async {
    if (editorMode != EditorMode.main) return Navigator.pop(context);

    if (editedBytes != null) {
      // Pre-cache the edited image to improve display performance.
      await precacheImage(MemoryImage(editedBytes!), context);
      if (!mounted) return;

      // Navigate to the preview page to display the edited image.
      editorKey.currentState?.isPopScopeDisabled = true;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PreviewImgPage(
              imgBytes: editedBytes!,
              generationTime: _generationTime,
              showThumbnail: showThumbnail,
              rawOriginalImage: rawOriginalImage,
              generationConfigs: generationConfigs,
            );
          },
        ),
      ).whenComplete(() {
        // Reset the state variables after navigation.
        editedBytes = null;
        _generationTime = null;
        startEditingTime = null;
      });
    }

    if (mounted && enablePop) {
      Navigator.pop(context);
    }
  }

  /// Preloads an image into memory to improve performance.
  ///
  /// Supports both asset and network images. Once the image is cached, it
  /// updates the
  /// [isPreCached] flag, triggers a widget rebuild, and optionally executes a
  /// callback.
  ///
  /// Parameters:
  /// - [assetPath]: The file path of the asset image to be cached.
  /// - [networkUrl]: The URL of the network image to be cached.
  /// - [onDone]: An optional callback executed after caching is complete.
  ///
  /// Ensures the widget is still mounted before performing operations.
  void preCacheImage({
    String? assetPath,
    String? networkUrl,
    Function()? onDone,
  }) {
    isPreCached = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      precacheImage(
              assetPath != null
                  ? AssetImage(assetPath)
                  : NetworkImage(networkUrl!) as ImageProvider,
              context)
          .whenComplete(() {
        if (!mounted) return;
        isPreCached = true;
        setState(() {});
        onDone?.call();
      });
    });
  }

  /// Vibrates the device briefly if enabled and supported.
  ///
  /// If the device supports custom vibrations, it uses the `Vibration.vibrate`
  /// method with a duration of 3 milliseconds to produce the vibration.
  ///
  /// On older Android devices, it initiates vibration using
  /// `Vibration.vibrate`, and then, after 3 milliseconds, cancels the
  /// vibration using `Vibration.cancel`.
  ///
  /// This function is used to provide haptic feedback when helper lines are
  /// interacted with, enhancing the user experience.
  void vibrateLineHit() {
    if (_deviceCanVibrate && _deviceCanCustomVibrate) {
      Vibration.vibrate(duration: 3);
    } else if (!kIsWeb && Platform.isAndroid) {
      /// On old android devices we can stop the vibration after 3 milliseconds
      /// iOS: only works for custom haptic vibrations using CHHapticEngine.
      /// This will set `deviceCanCustomVibrate` anyway to true so it's
      /// impossible to fake it.
      Vibration.vibrate();
      Future.delayed(const Duration(milliseconds: 3))
          .whenComplete(Vibration.cancel);
    }
  }
}
