import 'dart:typed_data';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

// ST25DV commands/registers, define in the ST25DV reference manual
class St25dv {
  int get writeMsgCmd => 0xaa;
  int get readMsgDmd => 0xac;
  int get readDynCfgCmd => 0xad;
  int get writeDynCfgCmd => 0xae;
  int get mfgCode => 0x02; // STMicroelectronics
  final defReqFlags = Iso15693RequestFlags(
    address: true,
    highDataRate: true,
  );

  Uint8List buildIso15693Header(int cmd, Uint8List tagId) {
    final b = BytesBuilder();
    b.addByte(defReqFlags.encode());
    b.addByte(cmd);
    b.addByte(mfgCode);

    b.add(tagId);
    return b.toBytes();
  }

  Uint8List buildMessage(int cmd, Uint8List tagId, Uint8List msg) {
    final b = BytesBuilder();
    b.add(buildIso15693Header(cmd, tagId));

    b.addByte(msg.lengthInBytes - 1);
    b.add(msg);

    return b.toBytes();
  }

  Uint8List buildReadDynCfgCmd(Uint8List tagId, int address) {
    final b = BytesBuilder();
    b.add(buildIso15693Header(readDynCfgCmd, tagId));

    b.addByte(address);

    return b.toBytes();
  }

  Uint8List buildWriteDynCfgCmd(Uint8List tagId, int address, int value) {
    final b = BytesBuilder();
    b.add(buildIso15693Header(writeDynCfgCmd, tagId));

    b.addByte(address);
    b.addByte(value);

    return b.toBytes();
  }
}
