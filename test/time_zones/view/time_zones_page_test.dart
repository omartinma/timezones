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
  group('TimeZonesPage', () {
    late TimeZoneRepository timeZoneRepository;
    final currentTime = DateTime.now();
    final timeZone1 = TimeZone(location: 'madrid', currentTime: currentTime);

    setUp(() {
      timeZoneRepository = MockTimeZoneRepository();
      when(() => timeZoneRepository.getTimeZones())
          .thenAnswer((_) async => [timeZone1]);
    });

    testWidgets('renders time zones view', (tester) async {
      await tester.pumpApp(
        const TimeZonesPage(),
        timeZoneRepository: timeZoneRepository,
      );

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

    testWidgets('renders TimeZonesLoadingView when loading', (tester) async {
      when(() => timeZonesBloc.state).thenReturn(TimeZonesState(
        status: TimeZonesStatus.loading,
      ));
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
      );
      expect(find.byType(TimeZonesLoadingView), findsOneWidget);
    });

    testWidgets('renders TimeZonesErrorView when error', (tester) async {
      when(() => timeZonesBloc.state).thenReturn(TimeZonesState(
        status: TimeZonesStatus.error,
      ));
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
      );
      expect(find.byType(TimeZonesErrorView), findsOneWidget);
    });

    testWidgets('renders TimeZonesPopulatedView when populated',
        (tester) async {
      when(() => timeZonesBloc.state).thenReturn(TimeZonesState(
        status: TimeZonesStatus.populated,
      ));
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
      );
      expect(find.byType(TimeZonesPopulatedView), findsOneWidget);
    });
  });
}
