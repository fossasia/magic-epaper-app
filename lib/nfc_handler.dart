import 'imagehandler.dart';
import 'epdutils.dart';
import 'dart:typed_data';

class NfcHandler
{
  Future<void> nfc_write() async {
    ImageHandler imageHandler = ImageHandler();
    // imageHandler.loadRaster('assets/images/tux-fit.png');
    await imageHandler.loadRaster('assets/images/black-red.png');
    var (red, black) = imageHandler.toEpdBiColor();

    int chunkSize = 220; // NFC tag can handle 255 bytes per chunk.
    List<Uint8List> redChunks = MagicEpd.divideUint8List(red, chunkSize);
    List<Uint8List> blackChunks = MagicEpd.divideUint8List(black, chunkSize);
    MagicEpd.writeChunk(blackChunks, redChunks);
  }
}