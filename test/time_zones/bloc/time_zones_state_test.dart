// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/time_zones/time_zones.dart';

void main() {
  group('TimeZonesState', () {
    test('supports value comparisons', () {
      final instanceA = TimeZonesState(timeSelected: DateTime.now());
      final instanceB = instanceA.copyWith();
      expect(instanceA, instanceB);
    });

    test('check time zones', () {
      final instanceA = TimeZonesState(
        timeZones: TimeZones(
          items: [
            TimeZone(
              location: 'location',
              currentTime: DateTime.now(),
              timezoneAbbreviation: 'timezoneAbbreviation',
              gmtOffset: 2,
            ),
          ],
        ),
      );
      expect(instanceA.timeZones.items.length, greaterThan(0));
    });
  });
}
