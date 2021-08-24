import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/time_zones/time_zones.dart';

import '../../helpers/helpers.dart';

extension on WidgetTester {
  Future<void> pumpTimeZoneTile(
    Widget child,
  ) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: child)));
  }
}

void main() {
  group('TimeZoneTile', () {
    testWidgets('renders TimeZoneOffset if offset different to 0',
        (tester) async {
      await tester.pumpTimeZoneTile(
        TimeZoneTile(timeZone: createTimeZoneStub(offset: 1)),
      );
      expect(find.byType(TimeZoneOffset), findsOneWidget);
    });

    testWidgets('does not render TimeZoneOffset if offset is 0',
        (tester) async {
      await tester.pumpTimeZoneTile(
        TimeZoneTile(timeZone: createTimeZoneStub(offset: 0)),
      );
      expect(find.byType(TimeZoneOffset), findsNothing);
    });
  });
}
