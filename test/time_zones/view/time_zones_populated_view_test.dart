import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/time_zones/time_zones.dart';
import '../../helpers/helpers.dart';

void main() {
  group('TimeZonesPopulatedView', () {
    testWidgets('renders TimeZoneTile', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: TimeZonesPopulatedView(
            timeZones: [
              TimeZone(location: 'location', currentTime: DateTime.now()),
              TimeZone(location: 'location1', currentTime: DateTime.now()),
            ],
          ),
        ),
      );

      expect(find.byType(TimeZoneTile), findsNWidgets(2));
    });
  });
}
