import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/time_zones/time_zones.dart';

void main() {
  group('TimeZonesBloc', () {
    test('initial state is PhotoboothState', () {
      expect(TimeZonesBloc().state, equals(TimeZonesState()));
    });
  });
}
