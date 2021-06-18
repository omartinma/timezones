import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezones/time_zones/time_zones.dart';
import '../../helpers/helpers.dart';

class MockTimeZonesBloc extends MockBloc<TimeZonesEvent, TimeZonesState>
    implements TimeZonesBloc {}

class FakeTimeZonesEvent extends Fake implements TimeZonesEvent {}

class FakeTimeZonesState extends Fake implements TimeZonesState {}

void main() {
  group('TimeZonesPage', () {
    testWidgets('renders time zones view', (tester) async {
      await tester.pumpApp(const TimeZonesPage());

      expect(find.byType(TimeZonesView), findsOneWidget);
    });
  });

  group('TimeZonesView', () {
    late TimeZonesBloc timeZonesBloc;

    setUp(() {
      timeZonesBloc = MockTimeZonesBloc();
      when(() => timeZonesBloc.state).thenReturn(TimeZonesState());
    });
    setUpAll(() {
      registerFallbackValue<TimeZonesEvent>(FakeTimeZonesEvent());
      registerFallbackValue<TimeZonesState>(FakeTimeZonesState());
    });

    testWidgets('renders time zones view', (tester) async {
      await tester.pumpApp(const TimeZonesView(), timezonesBloc: timeZonesBloc);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
