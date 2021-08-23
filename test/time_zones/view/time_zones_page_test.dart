// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/select_time/select_time.dart';
import 'package:timezones/time_zones/time_zones.dart';
import '../../helpers/helpers.dart';

class MockTimeZonesBloc extends MockBloc<TimeZonesEvent, TimeZonesState>
    implements TimeZonesBloc {}

class FakeTimeZonesEvent extends Fake implements TimeZonesEvent {}

class FakeTimeZonesState extends Fake implements TimeZonesState {}

class MockTimeZoneRepository extends Mock implements TimeZoneRepository {}

class MockSelectTimeBloc extends MockBloc<SelectTimeEvent, SelectTimeState>
    implements SelectTimeBloc {}

class FakeSelectTimeEvent extends Fake implements SelectTimeEvent {}

class FakeSelectTimeState extends Fake implements SelectTimeState {}

extension TimeZonesTester on WidgetTester {
  Future<void> pumpTimeZonesPage(
    Widget child, {
    required TimeZonesBloc timeZonesBloc,
    required SelectTimeBloc selectTimeBloc,
    TimeZoneRepository? timeZoneRepository,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: timeZonesBloc),
          BlocProvider.value(value: selectTimeBloc),
        ],
        child: child,
      ),
      timeZoneRepository: timeZoneRepository,
    );
  }
}

void main() {
  group('TimeZonesPage', () {
    late TimeZoneRepository timeZoneRepository;
    late SelectTimeBloc selectTimeBloc;

    setUpAll(() {
      registerFallbackValue<SelectTimeEvent>(FakeSelectTimeEvent());
      registerFallbackValue<SelectTimeState>(FakeSelectTimeState());
    });

    setUp(() {
      selectTimeBloc = MockSelectTimeBloc();
      timeZoneRepository = MockTimeZoneRepository();
      when(() => timeZoneRepository.getTimeZones())
          .thenAnswer((_) async => TimeZones());
      when(() => selectTimeBloc.state).thenReturn(
        SelectTimeState(DateTime.now()),
      );
    });

    testWidgets('renders time zones view', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: selectTimeBloc,
          child: TimeZonesPage(),
        ),
        timeZoneRepository: timeZoneRepository,
      );

      expect(find.byType(TimeZonesView), findsOneWidget);
    });
  });

  group('TimeZonesView', () {
    late TimeZonesBloc timeZonesBloc;
    late SelectTimeBloc selectTimeBloc;
    final currentTime = DateTime.now();
    final timeZones = createTimeZonesStub();

    setUp(() {
      timeZonesBloc = MockTimeZonesBloc();
      selectTimeBloc = MockSelectTimeBloc();

      when(() => timeZonesBloc.state)
          .thenReturn(TimeZonesState(timeSelected: currentTime));
      when(() => selectTimeBloc.state).thenReturn(
        SelectTimeState(DateTime.now()),
      );
    });

    setUpAll(() {
      registerFallbackValue<TimeZonesEvent>(FakeTimeZonesEvent());
      registerFallbackValue<TimeZonesState>(FakeTimeZonesState());
      registerFallbackValue<SelectTimeEvent>(FakeSelectTimeEvent());
      registerFallbackValue<SelectTimeState>(FakeSelectTimeState());
    });

    testWidgets('renders TimeZonesLoadingView when loading', (tester) async {
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
        selectTimeBloc: selectTimeBloc,
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
        selectTimeBloc: selectTimeBloc,
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
        selectTimeBloc: selectTimeBloc,
      );
      expect(find.byType(TimeZonesEmptyView), findsOneWidget);
    });

    testWidgets('renders TimeZonesPopulatedView when populated and no empty',
        (tester) async {
      when(() => timeZonesBloc.state).thenReturn(
        TimeZonesState(
          status: TimeZonesStatus.populated,
          timeZones: timeZones,
          timeSelected: currentTime,
        ),
      );
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
        selectTimeBloc: selectTimeBloc,
      );
      expect(find.byType(TimeZonesPopulatedView), findsOneWidget);
    });

    testWidgets('triggers fetch on search pop', (tester) async {
      when(() => timeZonesBloc.state).thenReturn(
        TimeZonesState(
          status: TimeZonesStatus.populated,
          timeZones: timeZones,
          timeSelected: currentTime,
        ),
      );
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
        selectTimeBloc: selectTimeBloc,
      );
      await tester.tap(find.byType(SearchButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Chicago');
      await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));
      await tester.pumpAndSettle();
      verify(
        () => timeZonesBloc.add(TimeZonesAddRequested(city: 'Chicago')),
      ).called(1);
    });

    testWidgets(
        'shows duplicated error snackbar when errorAddingStatus [duplicated]',
        (tester) async {
      whenListen(
        timeZonesBloc,
        Stream.fromIterable(<TimeZonesState>[
          TimeZonesState(errorAddingStatus: ErrorAddingStatus.duplicated),
        ]),
      );
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
        selectTimeBloc: selectTimeBloc,
      );
      await tester.pump();
      expect(
        find.byKey(Key('timeZonesView_duplicatedTimeZone_snackBar')),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows not found error snackbar when errorAddingStatus [notFound]',
        (tester) async {
      whenListen(
        timeZonesBloc,
        Stream.fromIterable(<TimeZonesState>[
          TimeZonesState(errorAddingStatus: ErrorAddingStatus.notFound),
        ]),
      );
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
        selectTimeBloc: selectTimeBloc,
      );
      await tester.pump();
      expect(
        find.byKey(Key('timeZonesView_notFoundTimeZone_snackBar')),
        findsOneWidget,
      );
    });

    testWidgets('updates time', (tester) async {
      final time = DateTime.now();
      whenListen(
        selectTimeBloc,
        Stream.fromIterable(<SelectTimeState>[
          SelectTimeState(time),
        ]),
      );
      await tester.pumpTimeZonesPage(
        const TimeZonesView(),
        timeZonesBloc: timeZonesBloc,
        selectTimeBloc: selectTimeBloc,
      );
      await tester.pump();
      verify(() => timeZonesBloc.add(TimeZonesTimeSelected(time: time)));
    });
  });
}
