import 'st25dv.dart';

class MagicEpaperFirmware {
  int get epdCmd => 0x00; // command packet, pull the epd's C/D pin to Low (CMD)
  int get epdSend => 0x01; // data packet, pull the epd's C/D pin to High (DATA)
  final tagChip = St25dv();
}