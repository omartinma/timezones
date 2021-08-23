import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_zones_ui/time_zones_ui.dart';

extension TimeZonesTester on WidgetTester {
  Future<void> pumpLiveClock(
    Widget child,
  ) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: child)));
  }
}

void main() {
  group('LiveClock', () {
    testWidgets('renders default LiveClock', (tester) async {
      final currentTime = DateTime.now();
      await tester.pumpLiveClock(LiveClock(
        initialDate: DateTime.now(),
      ));
      expect(find.text(currentTime.toHours()), findsOneWidget);
    });

    testWidgets('renders regular LiveClock', (tester) async {
      final currentTime = DateTime.now();
      await tester.pumpLiveClock(LiveClock.regular(
        initialDate: DateTime.now(),
      ));
      expect(find.text(currentTime.toHours()), findsOneWidget);
    });

    testWidgets('renders big LiveClock', (tester) async {
      final currentTime = DateTime.now();
      await tester.pumpLiveClock(LiveClock.big(
        initialDate: DateTime.now(),
      ));
      expect(find.text(currentTime.toHours()), findsOneWidget);
    });

    testWidgets('updates time correctly when timer increments', (tester) async {
      final currentTime = DateTime.now();
      await tester.pumpLiveClock(LiveClock.big(
        initialDate: DateTime.now(),
      ));
      expect(find.text(currentTime.toHours()), findsOneWidget);
      const increment = Duration(minutes: 60);
      await tester.pump(increment);
      final newTime = currentTime.add(increment);
      expect(find.text(newTime.toHours()), findsOneWidget);
    });

    testWidgets('updates widget properties if updated', (tester) async {
      final firstTime = DateTime.now();
      await tester.pumpLiveClock(
        LiveClock.big(key: const Key('unique'), initialDate: firstTime),
      );
      expect(find.text(firstTime.toHours()), findsOneWidget);

      final secondTime = firstTime.add(const Duration(minutes: 60));
      await tester.pumpLiveClock(
        LiveClock.big(key: const Key('unique'), initialDate: secondTime),
      );
      expect(find.text(firstTime.toHours()), findsNothing);
      expect(find.text(secondTime.toHours()), findsOneWidget);
    });
  });
}
