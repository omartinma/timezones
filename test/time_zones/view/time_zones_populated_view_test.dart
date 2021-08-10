import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/time_zones/time_zones.dart';
import '../../helpers/helpers.dart';

void main() {
  group('TimeZonesPopulatedView', () {
    testWidgets('renders TimeZoneTile', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: TimeZonesPopulatedView(
            timeZones: [
              createTimeZoneStub(),
              createTimeZoneStub(),
            ],
          ),
        ),
      );

      expect(find.byType(TimeZoneTile), findsNWidgets(2));
    });
  });
}
