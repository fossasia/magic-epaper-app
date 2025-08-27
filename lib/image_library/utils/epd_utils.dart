import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/gdey037z03.dart';
import 'package:magicepaperapp/util/epd/gdey037z03bw.dart';
import 'package:magicepaperapp/util/epd/waveshare_displays.dart';
import 'package:magicepaperapp/util/epd/gdeq031t10.dart';


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
      case 'waveshare-2.9b':
        return Waveshare2in9b();
      case 'waveshare-2.13':
        return Waveshare2in13();
      case 'waveshare-2.7':
        return Waveshare2in7();
      case 'waveshare-4.2':
        return Waveshare4in2();
      case 'waveshare-7.5':
        return Waveshare7in5();
      case 'waveshare-7.5-hd':
        return Waveshare7in5HD();
      case 'GDEQ031T10':
        return GDEQ031T10();
      default:
        return Gdey037z03();
    }
  }
}
