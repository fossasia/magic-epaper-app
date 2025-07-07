import 'driver.dart';

class DummyDriver extends Driver {
  @override
  int get refresh => 0x12;
  @override
  get driverName => 'NA';
  @override
  List<int> get transmissionLines => [0x10, 0x13];
}
