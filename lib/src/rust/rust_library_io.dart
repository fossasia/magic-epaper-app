import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';
import 'package:magicepaperapp/src/rust/frb_generated.dart';

Future<void> initRustLibrary() => RustLib.init(
  externalLibrary: Platform.isIOS || Platform.isMacOS
      ? ExternalLibrary.process(iKnowHowToUseIt: true)
      : null,
);
