import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

const kImageEditorExampleIsDesktopBreakPoint = 900;

/// A mixin that provides helper methods and state management for image editing
/// using the [ProImageEditor]. It is intended to be used in a [StatefulWidget].
mixin ExampleHelperState<T extends StatefulWidget> on State<T> {
  /// The global key used to reference the state of [ProImageEditor].
  final editorKey = GlobalKey<ProImageEditorState>();

  @override
  void initState() {
    super.initState();
    // Vibration logic has been removed.
  }

  /// Determines if the current layout should use desktop mode based on the
  /// screen width.
  bool isDesktopMode(BuildContext context) =>
      MediaQuery.sizeOf(context).width >=
      kImageEditorExampleIsDesktopBreakPoint;

  /// Preloads an image into memory to improve performance.
  void preCacheImage({
    String? assetPath,
    String? networkUrl,
    Function()? onDone,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      precacheImage(
        assetPath != null
            ? AssetImage(assetPath)
            : NetworkImage(networkUrl!) as ImageProvider,
        context,
      ).whenComplete(() {
        if (!mounted) return;
        setState(() {});
        onDone?.call();
      });
    });
  }
}
