// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/app/app.dart';
import 'package:timezones/home/home.dart';
import 'package:timezones/select_time/select_time.dart';
import '../helpers/helpers.dart';

class MockTimeZoneRepository extends Mock implements TimeZoneRepository {}

class MockSelectTimeBloc extends MockBloc<SelectTimeEvent, SelectTimeState>
    implements SelectTimeBloc {}

class FakeSelectTimeEvent extends Fake implements SelectTimeEvent {}

class FakeSelectTimeState extends Fake implements SelectTimeState {}

void main() {
  group('App', () {
    late TimeZoneRepository timeZoneRepository;

    setUp(() {
      timeZoneRepository = MockTimeZoneRepository();
      when(() => timeZoneRepository.getTimeZoneForLocation(any()))
          .thenAnswer((_) async => Future.value());
      when(() => timeZoneRepository.getTimeZones())
          .thenAnswer((_) async => TimeZones());
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpApp(
        App(timeZoneRepository: timeZoneRepository),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late TimeZoneRepository timeZoneRepository;
    late SelectTimeBloc selectTimeBloc;

    setUpAll(() {
      registerFallbackValue<SelectTimeEvent>(FakeSelectTimeEvent());
      registerFallbackValue<SelectTimeState>(FakeSelectTimeState());
    });

    setUp(() {
      timeZoneRepository = MockTimeZoneRepository();
      selectTimeBloc = MockSelectTimeBloc();
      final time = DateTime.now();
      when(() => timeZoneRepository.getTimeZoneForLocation(any()))
          .thenAnswer((_) async => Future.value());
      when(() => timeZoneRepository.getTimeZones())
          .thenAnswer((_) async => TimeZones());
      when(() => selectTimeBloc.state).thenReturn(
        SelectTimeState(time, time.timeZoneName),
      );
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: selectTimeBloc,
          child: AppView(),
        ),
        timeZoneRepository: timeZoneRepository,
      );
      await tester.pump();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
