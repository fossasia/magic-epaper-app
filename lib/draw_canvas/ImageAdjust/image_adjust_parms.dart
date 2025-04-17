import 'package:image/image.dart' as img;

class ImageAdjustParams {
  final img.Image image;
  final double brightness;
  final double contrast;

  ImageAdjustParams(this.image, this.brightness, this.contrast);
}
