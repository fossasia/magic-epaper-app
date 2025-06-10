import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/pro_image_editor/features/movable_background_image.dart';
import 'package:magic_epaper_app/view/widget/image_list.dart'; // We will create/update this
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

import 'package:magic_epaper_app/provider/image_loader.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/constants.dart';
import 'package:magic_epaper_app/util/protocol.dart';

class ImageEditor extends StatefulWidget {
  final Epd epd;
  const ImageEditor({super.key, required this.epd});

  @override
  ImageEditorState createState() => ImageEditorState();
}

class ImageEditorState extends State<ImageEditor> {
  int _selectedFilterIndex = 0;
  // This will store the original image that was used to generate the filters
  img.Image? _processedSourceImage;
  // This list will hold the pre-processed image data (as bytes)
  List<Uint8List> _processedPngs = [];
  List<img.Image> _rawImages = [];

  void _onFilterSelected(int index) {
    // Only rebuild the state if the selection changes
    if (_selectedFilterIndex != index) {
      setState(() {
        _selectedFilterIndex = index;
      });
    }
  }

  // This method will be responsible for the expensive image processing.
  void _processImages(img.Image? sourceImage) {
    if (sourceImage == null) {
      // Clear lists if source is null
      if (_processedPngs.isNotEmpty) {
        setState(() {
          _processedSourceImage = null;
          _processedPngs = [];
          _rawImages = [];
        });
      }
      return;
    }

    // Key Performance Fix: Only re-process if the source image has actually changed.
    if (_processedSourceImage == sourceImage) {
      return;
    }

    // The expensive work happens here, and only when needed.
    final image = img.copyResize(sourceImage,
        width: widget.epd.width, height: widget.epd.height);

    _rawImages =
        widget.epd.processingMethods.map((method) => method(image)).toList();
    _processedPngs = _rawImages
        .map((rawImg) => img.encodePng(img.copyRotate(rawImg, angle: 90)))
        .toList();

    // Update the state with the new processed images
    setState(() {
      _processedSourceImage = sourceImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch for new images from the provider
    var imgLoader = context.watch<ImageLoader>();
    _processImages(imgLoader.image);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: colorAccent,
        elevation: 0,
        title: const Text('Select a Filter',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          if (_processedPngs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TextButton(
                onPressed: () {
                  Protocol(epd: widget.epd)
                      .writeImages(_rawImages[_selectedFilterIndex]);
                },
                style: TextButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                        color: Colors.white, width: 1), // Added white border),
                  ),
                ),
                child: const Text('Transfer'),
              ),
            ),
        ],
      ),
      body: _processedPngs.isNotEmpty
          ? ImageList(
              key: ValueKey(
                  _processedSourceImage), // Ensures list rebuilds on new image
              processedPngs: _processedPngs,
              epd: widget.epd,
              onFilterSelected: _onFilterSelected,
              selectedIndex: _selectedFilterIndex,
            )
          : const Center(
              child: Text(
                "Import an image to begin",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
      bottomNavigationBar: BottomActionMenu(
        epd: widget.epd,
        imgLoader: imgLoader,
      ),
    );
  }
}

// New Widget for the Horizontally Scrolling Bottom Bar
class BottomActionMenu extends StatelessWidget {
  final Epd epd;
  final ImageLoader imgLoader;

  const BottomActionMenu(
      {super.key, required this.epd, required this.imgLoader});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                final canvasBytes = await Navigator.of(context).push<Uint8List>(
                  MaterialPageRoute(
                    builder: (context) => const MovableBackgroundImageExample(),
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
            // You can easily add more buttons here in the future
            // _buildActionButton(
            //   context: context,
            //   icon: Icons.settings_outlined,
            //   label: 'Settings',
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    ));
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      // Add horizontal padding here to space out the buttons
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: onTap,
        // This makes the splash effect a circle, which looks nice for icons
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          // Padding inside the InkWell defines the tappable area
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colorAccent, size: 26),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(color: Colors.black, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}