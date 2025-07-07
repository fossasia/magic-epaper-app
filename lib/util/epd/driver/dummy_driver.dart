import 'driver.dart';

class DummyDriver extends Driver {
  @override
  int get refresh => 0;
  @override
  get driverName => 'NA';
  @override
  List<int> get transmissionLines => [];
}
