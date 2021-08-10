// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/time_zones/time_zones.dart';

import '../../helpers/helpers.dart';

class MockTimeZoneRepository extends Mock implements TimeZoneRepository {}

class FakeTimeZones extends Fake implements TimeZones {}

void main() {
  group('TimeZonesBloc', () {
    late TimeZoneRepository timeZoneRepository;
    final currentTime = DateTime.now();

    final timeZones = createTimeZonesStub();

    setUp(() {
      timeZoneRepository = MockTimeZoneRepository();
    });

    test('initial state is TimeZonesState.loading', () {
      expect(
        TimeZonesBloc(
          timeZoneRepository: timeZoneRepository,
        ).state,
        equals(
          isA<TimeZonesState>().having(
            (state) => state.status,
            'status',
            TimeZonesStatus.loading,
          ),
        ),
      );
    });

    group('TimeZonesFetchRequested', () {
      blocTest<TimeZonesBloc, TimeZonesState>(
        'emits [loading, populates] when success',
        build: () {
          when(() => timeZoneRepository.getTimeZones())
              .thenAnswer((_) async => timeZones);
          return TimeZonesBloc(
            timeZoneRepository: timeZoneRepository,
          );
        },
        act: (bloc) => bloc.add(TimeZonesFetchRequested()),
        expect: () => [
          isA<TimeZonesState>().having(
            (state) => state.status,
            'status',
            TimeZonesStatus.loading,
          ),
          isA<TimeZonesState>()
              .having(
                (state) => state.status,
                'status',
                TimeZonesStatus.populated,
              )
              .having(
                (state) => state.timeZones,
                'timeZones',
                timeZones,
              ),
        ],
      );

      blocTest<TimeZonesBloc, TimeZonesState>(
        'emits [loading, error] '
        'when timeZoneRepository.getTimeZones throws',
        build: () {
          when(
            () => timeZoneRepository.getTimeZones(),
          ).thenThrow(Exception());
          return TimeZonesBloc(timeZoneRepository: timeZoneRepository);
        },
        act: (bloc) => bloc.add(TimeZonesFetchRequested()),
        expect: () => [
          isA<TimeZonesState>().having(
            (state) => state.status,
            'status',
            TimeZonesStatus.loading,
          ),
          isA<TimeZonesState>().having(
            (state) => state.status,
            'status',
            TimeZonesStatus.error,
          ),
        ],
      );
    });

    group('TimeZonesAddRequested', () {
      blocTest<TimeZonesBloc, TimeZonesState>(
        'emits [loading, populates] when success',
        build: () {
          when(() => timeZoneRepository.addTimeZone('madrid', any()))
              .thenAnswer((_) async => timeZones);
          return TimeZonesBloc(timeZoneRepository: timeZoneRepository);
        },
        act: (bloc) => bloc.add(TimeZonesAddRequested(city: 'madrid')),
        expect: () => [
          isA<TimeZonesState>().having(
            (state) => state.status,
            'status',
            TimeZonesStatus.loading,
          ),
          isA<TimeZonesState>()
              .having(
                (state) => state.status,
                'status',
                TimeZonesStatus.populated,
              )
              .having(
                (state) => state.timeZones,
                'timeZones',
                timeZones,
              ),
        ],
      );

      blocTest<TimeZonesBloc, TimeZonesState>(
        'emits [loading, error] when there is an exception',
        build: () {
          when(() => timeZoneRepository.addTimeZone('madrid', currentTime))
              .thenThrow(Exception());
          return TimeZonesBloc(timeZoneRepository: timeZoneRepository);
        },
        act: (bloc) => bloc.add(TimeZonesAddRequested(city: 'madrid')),
        expect: () => [
          isA<TimeZonesState>().having(
            (state) => state.status,
            'status',
            TimeZonesStatus.loading,
          ),
          isA<TimeZonesState>().having(
            (state) => state.status,
            'status',
            TimeZonesStatus.error,
          ),
        ],
      );
    });

    group('TimeZonesTimeSelected', () {
      final time = DateTime.now();

      setUpAll(() {
        registerFallbackValue(FakeTimeZones());
      });
      blocTest<TimeZonesBloc, TimeZonesState>(
        'emits updated time zones',
        build: () {
          when(() => timeZoneRepository.convertTimeZones(any(), any()))
              .thenReturn(timeZones);
          return TimeZonesBloc(timeZoneRepository: timeZoneRepository);
        },
        act: (bloc) => bloc.add(TimeZonesTimeSelected(time: time)),
        expect: () => [
          isA<TimeZonesState>().having(
            (state) => state.timeSelected,
            'timeSelected',
            time,
          ),
        ],
      );
    });
  });
}
