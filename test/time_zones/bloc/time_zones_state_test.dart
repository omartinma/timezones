// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/time_zones/time_zones.dart';

void main() {
  group('TimeZonesState', () {
    test('supports value comparisons', () {
      final instanceA = TimeZonesState();
      final instanceB = instanceA.copyWith();
      expect(instanceA, instanceB);
    });
  });
}
