// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/time_zones/time_zones.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TimeZonesEvent', () {
    group('TimeZonesFetchRequested', () {
      test('supports value comparison', () {
        final instanceA = TimeZonesFetchRequested();
        final instanceB = TimeZonesFetchRequested();
        expect(instanceA, equals(instanceB));
      });
    });

    group('TimeZonesAddRequested', () {
      test('supports value comparison', () {
        final instanceA = TimeZonesAddRequested(city: 'madrid');
        final instanceB = TimeZonesAddRequested(city: 'madrid');
        expect(instanceA, equals(instanceB));
      });
    });

    group('TimeZonesTimeSelected', () {
      test('supports value comparison', () {
        final time = DateTime.now();
        final instanceA = TimeZonesTimeSelected(time: time);
        final instanceB = TimeZonesTimeSelected(time: time);
        expect(instanceA, equals(instanceB));
      });
    });

    group('TimeZonesDeleteRequested', () {
      test('supports value comparison', () {
        final instanceA = TimeZonesDeleteRequested(
          timeZone: createTimeZoneStub(),
        );
        final instanceB = TimeZonesDeleteRequested(
          timeZone: createTimeZoneStub(),
        );
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
