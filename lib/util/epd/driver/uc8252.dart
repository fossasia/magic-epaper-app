import 'driver.dart';

// UC8253 commands/registers,
// define in the epaper display controller (UC8253) reference manual
class Uc8252 implements Driver {
  @override
  int get startTransmission1 => 0x10;

  @override
  int get refresh => 0x12;

  @override
  int get startTransmission2 => 0x13;

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
