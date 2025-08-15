import 'package:magicepaperapp/util/epd/gdeq031t10.dart';
import 'package:magicepaperapp/util/epd/gdey037z03.dart';
import 'package:magicepaperapp/util/epd/gdey037z03bw.dart';
import 'package:magicepaperapp/util/epd/epd.dart';

class EpdUtils {
  static Epd getEpdFromMetadata(Map<String, dynamic>? metadata) {
    final List<Epd> displays = [Gdey037z03(), Gdey037z03BW(), GDEQ031T10()];

    if (metadata == null || !metadata.containsKey('epdModel')) {
      return displays[0];
    }

    final String epdModel = metadata['epdModel']?.toString() ?? '';

    switch (epdModel) {
      case 'GDEY037Z03':
        return Gdey037z03();
      case 'GDEY037T03':
        return Gdey037z03BW();
      case 'GDEQ031T10':
        return GDEQ031T10();
      default:
        return displays[0];
    }
  }
}
