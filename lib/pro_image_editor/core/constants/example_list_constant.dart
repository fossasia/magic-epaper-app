import 'package:flutter/material.dart';

import '../../features/crop_to_main_editor.dart';
import '../../features/custom_widgets_example.dart';
import '../../features/default_example.dart';
import '../../features/design_examples/design_example.dart';
import '../../features/emoji_translate_example.dart';
import '../../features/frame_example.dart';
import '../../features/generation_configs_example.dart';
import '../../features/google_font_example.dart';
import '../../features/image_format_convert_example.dart';
import '../../features/import_export_example.dart';
import '../../features/movable_background_image.dart';
import '../../features/pick_image_example.dart';
import '../../features/reorder_layer_example.dart';
import '../../features/round_cropper_example.dart';
import '../../features/selectable_layer_example.dart';
import '../../features/signature_drawing_example.dart';
import '../../features/standalone_example.dart';
import '../../features/stickers_example.dart';
import '../../features/zoom_example.dart';
import '../models/example_model.dart';

/// A predefined list of examples for the image editor application.
///
/// Each [Example] in this list contains:
/// - [path]: A unique navigation route for the example.
/// - [name]: A user-friendly name for the example.
/// - [icon]: An [IconData] representing the example visually.
/// - [page]: A [Widget] representing the content of the example.
///
/// These examples showcase various features of the image editor, such as
/// cropping, layering, importing/exporting, and integration with services
/// like Firebase or Supabase.
List<Example> kImageEditorExamples = const [
  Example(
    path: '/default',
    name: 'Default-Editor',
    icon: Icons.dashboard_outlined,
    page: DefaultExample(),
  ),
  Example(
    path: '/designs',
    name: 'Designs',
    icon: Icons.palette_outlined,
    page: DesignExample(),
  ),
  Example(
    path: '/standalone',
    name: 'Standalone-Editors',
    icon: Icons.view_in_ar_outlined,
    page: StandaloneExample(),
  ),
  Example(
    path: '/init-crop-editor',
    name: 'Start with Crop-Editor',
    icon: Icons.crop,
    page: CropToMainEditorExample(),
  ),
  Example(
    path: '/signature-drawing',
    name: 'Signature/ Drawing',
    icon: Icons.draw_outlined,
    page: SignatureDrawingExample(),
  ),
  Example(
    path: '/stickers',
    name: 'Stickers',
    icon: Icons.image_outlined,
    page: StickersExample(),
  ),
  Example(
    path: '/reorder',
    name: 'Reorder-Layers',
    icon: Icons.sort,
    page: ReorderLayerExample(),
  ),
  Example(
    path: '/round-cropper',
    name: 'Round-Cropper',
    icon: Icons.supervised_user_circle_outlined,
    page: RoundCropperExample(),
  ),
  Example(
    path: '/selectable-layers',
    name: 'Selectable-Layers',
    icon: Icons.select_all_rounded,
    page: SelectableLayerExample(),
  ),
  Example(
    path: '/generation-configs',
    name: 'Generation-Configurations',
    icon: Icons.memory_outlined,
    page: GenerationConfigsExample(),
  ),
  Example(
    path: '/camera-gallery-picker',
    name: 'Camera-Gallery-Picker',
    icon: Icons.attachment_rounded,
    page: PickImageExample(),
  ),
  Example(
    path: '/google-font',
    name: 'Google-Font',
    icon: Icons.font_download_outlined,
    page: GoogleFontExample(),
  ),
  Example(
    path: '/custom-widgets',
    name: 'Custom-Widgets',
    icon: Icons.dashboard_customize_outlined,
    page: CustomWidgetsExample(),
  ),
  Example(
    path: '/import-export',
    name: 'Import-Export',
    icon: Icons.import_export_rounded,
    page: ImportExportExample(),
  ),
  Example(
    path: '/movable',
    name: 'Movable-Background',
    icon: Icons.pan_tool_alt_outlined,
    page: MovableBackgroundImageExample(),
  ),
  Example(
    path: '/emoji-translate',
    name: 'Emoji-Translate',
    icon: Icons.emoji_emotions_outlined,
    page: EmojiTranslateExample(),
  ),
  Example(
    path: '/zoom',
    name: 'Zoom',
    icon: Icons.zoom_in_outlined,
    page: ZoomExample(),
  ),
  Example(
    path: '/output-format',
    name: 'Output-Format',
    icon: Icons.compare_outlined,
    page: ImageFormatConvertExample(),
  ),
  Example(
    path: '/frame',
    name: 'Frame',
    icon: Icons.filter_frames_outlined,
    page: FrameExample(),
  ),
];
