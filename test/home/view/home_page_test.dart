// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/home/home.dart';
import 'package:timezones/select_time/select_time.dart';
import '../../helpers/helpers.dart';

class MockSelectTimeBloc extends MockBloc<SelectTimeEvent, SelectTimeState>
    implements SelectTimeBloc {}

class FakeSelectTimeEvent extends Fake implements SelectTimeEvent {}

class FakeSelectTimeState extends Fake implements SelectTimeState {}

extension TimeZonesTester on WidgetTester {
  Future<void> pumpHomePage(
    Widget child, {
    required SelectTimeBloc selectTimeBloc,
    required TimeZoneRepository timeZoneRepository,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: selectTimeBloc),
        ],
        child: child,
      ),
      timeZoneRepository: timeZoneRepository,
    );
  }
}

void main() {
  group('HomePage', () {
    late TimeZoneRepository timeZoneRepository;
    late SelectTimeBloc selectTimeBloc;

    setUpAll(() {
      registerFallbackValue<SelectTimeEvent>(FakeSelectTimeEvent());
      registerFallbackValue<SelectTimeState>(FakeSelectTimeState());
    });

    setUp(() {
      selectTimeBloc = MockSelectTimeBloc();
      timeZoneRepository = MockTimeZoneRepository();
      when(() => selectTimeBloc.state).thenReturn(
        SelectTimeState(DateTime.now()),
      );
      when(() => timeZoneRepository.getTimeZones())
          .thenAnswer((_) async => TimeZones());
    });

    testWidgets('tapping on TimeZones label selects TimeZonesPage',
        (tester) async {
      await tester.pumpHomePage(
        HomePage(),
        selectTimeBloc: selectTimeBloc,
        timeZoneRepository: timeZoneRepository,
      );
      await tester.tap(find.text('TimeZones'));
      await tester.pumpAndSettle();
      final indexedStack = tester.findWidgetByType<IndexedStack>();
      expect(indexedStack.index, 0);
    });

    testWidgets('tapping on People label selects Container', (tester) async {
      await tester.pumpHomePage(
        HomePage(),
        selectTimeBloc: selectTimeBloc,
        timeZoneRepository: timeZoneRepository,
      );
      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();
      final indexedStack = tester.findWidgetByType<IndexedStack>();
      expect(indexedStack.index, 1);
    });
  });
}
