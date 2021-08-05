// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/time_zones/time_zones.dart';

class MockTimeZoneRepository extends Mock implements TimeZoneRepository {}

void main() {
  group('TimeZonesBloc', () {
    late TimeZoneRepository timeZoneRepository;
    final currentTime = DateTime.now();
    final timeZone1 = TimeZone(
      location: 'madrid',
      currentTime: currentTime,
      timezoneAbbreviation: 'CEST',
    );
    final timeZones = TimeZones(items: [timeZone1]);

    setUp(() {
      timeZoneRepository = MockTimeZoneRepository();
    });

    test('initial state is TimeZonesState.loading', () {
      expect(
        TimeZonesBloc(timeZoneRepository: timeZoneRepository).state,
        equals(TimeZonesState()),
      );
    });

    group('TimeZonesFetchRequested', () {
      blocTest<TimeZonesBloc, TimeZonesState>(
        'emits [loading, populates] when success',
        build: () {
          when(() => timeZoneRepository.getTimeZones())
              .thenAnswer((_) async => timeZones);
          return TimeZonesBloc(timeZoneRepository: timeZoneRepository);
        },
        act: (bloc) => bloc.add(TimeZonesFetchRequested()),
        expect: () => [
          TimeZonesState(),
          TimeZonesState(
            status: TimeZonesStatus.populated,
            timeZones: timeZones,
          )
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
          when(() => timeZoneRepository.addTimeZone('madrid'))
              .thenAnswer((_) async => timeZones);
          return TimeZonesBloc(timeZoneRepository: timeZoneRepository);
        },
        act: (bloc) => bloc.add(TimeZonesAddRequested(city: 'madrid')),
        expect: () => [
          TimeZonesState(),
          TimeZonesState(
            status: TimeZonesStatus.populated,
            timeZones: timeZones,
          )
        ],
      );

      blocTest<TimeZonesBloc, TimeZonesState>(
        'emits [loading, error] when there is an exception',
        build: () {
          when(() => timeZoneRepository.addTimeZone('madrid'))
              .thenThrow(Exception());
          return TimeZonesBloc(timeZoneRepository: timeZoneRepository);
        },
        act: (bloc) => bloc.add(TimeZonesAddRequested(city: 'madrid')),
        expect: () => [
          TimeZonesState(),
          TimeZonesState(
            status: TimeZonesStatus.error,
          )
        ],
      );
    });
  });
}
