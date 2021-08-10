// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/time_zones/time_zones.dart';
import '../../helpers/helpers.dart';

class MockTimeZonesBloc extends MockBloc<TimeZonesEvent, TimeZonesState>
    implements TimeZonesBloc {}

class FakeTimeZonesEvent extends Fake implements TimeZonesEvent {}

class FakeTimeZonesState extends Fake implements TimeZonesState {}

class MockTimeZoneRepository extends Mock implements TimeZoneRepository {}

extension TimeZonesTester on WidgetTester {
  Future<void> pumpTimeZonesPage(
    Widget child, {
    required TimeZonesBloc timeZonesBloc,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: timeZonesBloc),
        ],
        child: child,
      ),
    );
  }
}

void main() {
  group('SelectTimeView', () {
    late TimeZonesBloc timeZonesBloc;
    final currentTime = DateTime.now();

    setUp(() {
      timeZonesBloc = MockTimeZonesBloc();
      when(() => timeZonesBloc.state)
          .thenReturn(TimeZonesState(timeSelected: currentTime));
    });

    setUpAll(() {
      registerFallbackValue<TimeZonesEvent>(FakeTimeZonesEvent());
      registerFallbackValue<TimeZonesState>(FakeTimeZonesState());
    });

    testWidgets('calls to update time', (tester) async {
      await tester.pumpTimeZonesPage(
        Scaffold(bottomNavigationBar: SelectTimeView()),
        timeZonesBloc: timeZonesBloc,
      );
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      verify(() => timeZonesBloc.add(any(that: isA<TimeZonesTimeSelected>())))
          .called(1);
    });
  });
}
