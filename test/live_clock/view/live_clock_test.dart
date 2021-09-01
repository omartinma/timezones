// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_zones_ui/time_zones_ui.dart';
import 'package:timezones/live_clock/live_clock.dart';

extension on WidgetTester {
  Future<void> pumpLiveClock(
    Widget child,
  ) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: child)));
  }
}

void main() {
  final time = DateTime.now();
  group('LiveClock', () {
    testWidgets('renders LiveClockView', (tester) async {
      await tester.pumpLiveClock(LiveClock(time: DateTime.now()));
      expect(find.text(time.toHours()), findsOneWidget);
    });

    testWidgets('renders regular LiveClock', (tester) async {
      final currentTime = DateTime.now();
      await tester.pumpLiveClock(LiveClock.regular(
        time: currentTime,
      ));
      expect(find.text(time.toHours()), findsOneWidget);
    });

    testWidgets('renders big LiveClock', (tester) async {
      final currentTime = DateTime.now();
      await tester.pumpLiveClock(LiveClock.big(
        time: currentTime,
      ));
      expect(find.text(time.toHours()), findsOneWidget);
    });
  });
}
