import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/pro_image_editor/features/movable_background_image.dart';
import 'package:magic_epaper_app/util/image_editor_utils.dart';
import 'package:magic_epaper_app/view/widget/image_list.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

import 'package:magic_epaper_app/provider/image_loader.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/util/protocol.dart';

class ImageEditor extends StatefulWidget {
  final Epd epd;
  const ImageEditor({super.key, required this.epd});

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  bool flipHorizontal = false;
  bool flipVertical = false;

  void toggleFlipHorizontal() {
    setState(() {
      flipHorizontal = !flipHorizontal;
    });
  }

  void toggleFlipVertical() {
    setState(() {
      flipVertical = !flipVertical;
    });
  }

  @override
  Widget build(BuildContext context) {
    var imgLoader = context.watch<ImageLoader>();
    final orgImg = imgLoader.image;

    final List<img.Image> processedImgs = orgImg != null
        ? processImages(
            originalImage: orgImg,
            epd: widget.epd,
          )
        : [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colorAccent,
        elevation: 0,
        title: const Text(
          'Select a Filter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          if (processedImgs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TextButton(
                onPressed: () {
                  img.Image finalImg = processedImgs[0];
                  if (flipHorizontal) {
                    finalImg = img.flipHorizontal(finalImg);
                  }
                  if (flipVertical) {
                    finalImg = img.flipVertical(finalImg);
                  }
                  Protocol(epd: widget.epd).writeImages(finalImg);
                },
                style: TextButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white, width: 1),
                  ),
                ),
                child: const Text('Transfer'),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: processedImgs.isNotEmpty
              ? ImageList(
                  imgList: processedImgs,
                  epd: widget.epd,
                  flipHorizontal: flipHorizontal,
                  flipVertical: flipVertical,
                  onFlipHorizontal: toggleFlipHorizontal,
                  onFlipVertical: toggleFlipVertical,
                )
              : const Center(
                  child: Text(
                    "Import an image to begin",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: BottomActionMenu(
        epd: widget.epd,
        imgLoader: imgLoader,
      ),
    );
  }
}

class BottomActionMenu extends StatelessWidget {
  final Epd epd;
  final ImageLoader imgLoader;

  const BottomActionMenu({
    super.key,
    required this.epd,
    required this.imgLoader,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildActionButton(
                context: context,
                icon: Icons.add_photo_alternate_outlined,
                label: 'Import New',
                onTap: () {
                  imgLoader.pickImage(width: epd.width, height: epd.height);
                },
              ),
              _buildActionButton(
                context: context,
                icon: Icons.edit_outlined,
                label: 'Open Editor',
                onTap: () async {
                  final canvasBytes =
                      await Navigator.of(context).push<Uint8List>(
                    MaterialPageRoute(
                      builder: (context) =>
                          const MovableBackgroundImageExample(),
                    ),
                  );
                  if (canvasBytes != null) {
                    imgLoader.updateImage(
                      bytes: canvasBytes,
                      width: epd.width,
                      height: epd.height,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colorAccent, size: 26),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(color: colorBlack, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
