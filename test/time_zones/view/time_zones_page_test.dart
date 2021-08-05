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

    setUp(() {
      timeZoneRepository = MockTimeZoneRepository();
      when(() => timeZoneRepository.getTimeZones())
          .thenAnswer((_) async => TimeZones());
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
    final currentTime = DateTime.now();
    final timeZone1 = TimeZone(
      location: 'madrid',
      currentTime: currentTime,
      timezoneAbbreviation: 'CEST',
    );
    final timeZones = TimeZones(items: [timeZone1]);

    setUp(() {
      timeZonesBloc = MockTimeZonesBloc();
      when(() => timeZonesBloc.state).thenReturn(TimeZonesState());
    });
    setUpAll(() {
      registerFallbackValue<TimeZonesEvent>(FakeTimeZonesEvent());
      registerFallbackValue<TimeZonesState>(FakeTimeZonesState());
    });

    testWidgets('renders TimeZonesLoadingView when loading', (tester) async {
      when(() => timeZonesBloc.state).thenReturn(TimeZonesState());
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

    testWidgets('renders TimeZonesEmptyView when populated but empty',
        (tester) async {
      when(() => timeZonesBloc.state).thenReturn(TimeZonesState(
        status: TimeZonesStatus.populated,
      ));
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
      );
      expect(find.byType(TimeZonesEmptyView), findsOneWidget);
    });

    testWidgets('renders TimeZonesPopulatedView when populated and no empty',
        (tester) async {
      when(() => timeZonesBloc.state).thenReturn(
        TimeZonesState(
          status: TimeZonesStatus.populated,
          timeZones: timeZones,
        ),
      );
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
      );
      expect(find.byType(TimeZonesPopulatedView), findsOneWidget);
    });

    testWidgets('triggers fetch on search pop', (tester) async {
      when(() => timeZonesBloc.state).thenReturn(
        TimeZonesState(
          status: TimeZonesStatus.populated,
          timeZones: timeZones,
        ),
      );
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Chicago');
      await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));
      await tester.pumpAndSettle();
      verify(
        () => timeZonesBloc.add(TimeZonesAddRequested(city: 'Chicago')),
      ).called(1);
    });
  });
}
