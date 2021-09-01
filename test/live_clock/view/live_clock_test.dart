// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zones_ui/time_zones_ui.dart';
import 'package:timezones/live_clock/live_clock.dart';

class MockLiveClockBloc extends MockBloc<LiveClockEvent, LiveClockState>
    implements LiveClockBloc {}

class FakeLiveClockEvent extends Fake implements LiveClockEvent {}

class FakeLiveClockState extends Fake implements LiveClockState {}

extension on WidgetTester {
  Future<void> pumpLiveClock(
    Widget child,
  ) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: child)));
  }
}

extension on WidgetTester {
  Future<void> pumpLiveClockView(
    Widget child, {
    required LiveClockBloc liveClockBloc,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(value: liveClockBloc, child: child),
        ),
      ),
    );
  }
}

void main() {
  group('LiveClock', () {
    testWidgets('renders LiveClockView', (tester) async {
      await tester.pumpLiveClock(LiveClock(
        initialDate: DateTime.now(),
      ));
      expect(find.byType(LiveClockView), findsOneWidget);
    });

    testWidgets('renders regular LiveClock', (tester) async {
      final currentTime = DateTime.now();
      await tester.pumpLiveClock(LiveClock.regular(
        initialDate: currentTime,
      ));
      expect(find.byType(LiveClockView), findsOneWidget);
    });

    testWidgets('renders big LiveClock', (tester) async {
      final currentTime = DateTime.now();
      await tester.pumpLiveClock(LiveClock.big(
        initialDate: currentTime,
      ));
      expect(find.byType(LiveClockView), findsOneWidget);
    });
  });

  group('LiveClockView', () {
    late LiveClockBloc liveClockBloc;

    setUp(() {
      liveClockBloc = MockLiveClockBloc();
    });

    setUpAll(() {
      registerFallbackValue<LiveClockEvent>(FakeLiveClockEvent());
      registerFallbackValue<LiveClockState>(FakeLiveClockState());
    });

    testWidgets('displays correct time', (tester) async {
      final time = DateTime.now();
      when(() => liveClockBloc.state).thenReturn(LiveClockState(time: time));

      await tester.pumpLiveClockView(
        LiveClockView(textStyle: TextStyle()),
        liveClockBloc: liveClockBloc,
      );
      expect(find.text(time.toHours()), findsOneWidget);
    });
  });
}
