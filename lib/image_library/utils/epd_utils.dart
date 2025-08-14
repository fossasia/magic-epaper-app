import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/gdey037z03.dart';
import 'package:magicepaperapp/util/epd/gdey037z03bw.dart';
import 'package:magicepaperapp/util/epd/waveshare_2in9.dart';

class EpdUtils {
  static DisplayDevice getEpdFromMetadata(Map<String, dynamic>? metadata) {

    if (metadata == null || !metadata.containsKey('epdModel')) {
      return Gdey037z03();
   }

    final String epdModel = metadata['epdModel']?.toString() ?? '';

    switch (epdModel) {
      case 'GDEY037Z03':
        return Gdey037z03();
      case 'GDEY037T03':
        return Gdey037z03BW();
      case 'waveshare-2.9':
        return Waveshare2in9(); 
      default:
        return Gdey037z03();
    }
  }
}
