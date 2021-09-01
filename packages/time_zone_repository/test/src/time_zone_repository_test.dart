// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:instant/instant.dart';
import 'package:location_api/location_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storage/storage.dart';
import 'package:test/test.dart';
import 'package:time_zone_api/time_zone_api.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

class MockTimeZoneApi extends Mock implements TimeZoneApi {}

class MockLocationApi extends Mock implements LocationApi {}

class MockStorage extends Mock implements Storage {}

void main() {
  group('TimeZoneRepository', () {
    late TimeZoneRepository timeZoneRepository;
    late TimeZoneApi timeZoneApi;
    late LocationApi locationApi;
    late Storage storage;
    const cacheKey = '_timeZoneCacheKey';
    final location = Location(
      title: 'title',
      latLng: LatLng(latitude: 0, longitude: 0),
      woeid: 0,
    );
    final time = DateTime.now();

    final timeZoneApiResponse = TimeZoneApiResponse(
      datetime: time,
      timezoneAbbreviation: 'CEST',
      gmtOffset: 2,
    );
    const timeZonesJson = '''
{
   "items":[
      {
         "location":"Chicago",
         "currentTime":"2021-08-05T06:08:02.000",
         "timezoneAbbreviation":"CDT",
         "gmtOffset" : 0
      }
   ]
}
''';
    final timeZones =
        TimeZones.fromJson(jsonDecode(timeZonesJson) as Map<String, dynamic>);

    setUp(() {
      timeZoneApi = MockTimeZoneApi();
      locationApi = MockLocationApi();
      storage = MockStorage();

      when(() => storage.read(key: cacheKey))
          .thenAnswer((_) => Future.value(timeZonesJson));
      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer(
        (_) => Future.value(),
      );
      when(() => timeZoneApi.getTimeZone(any(), any())).thenAnswer(
        (_) async => timeZoneApiResponse,
      );
      when(() => locationApi.locationSearch(any())).thenAnswer(
        (_) async => location,
      );
      timeZoneRepository = TimeZoneRepository(
        timeZoneApi: timeZoneApi,
        locationApi: locationApi,
        storage: storage,
        timeZoneName: 'CEST',
      );
    });

    test('can instantiate without time zone name', () {
      expect(
        TimeZoneRepository(
          timeZoneApi: timeZoneApi,
          locationApi: locationApi,
          storage: storage,
        ),
        isNotNull,
      );
    });

    group('getTimeZoneForLocation', () {
      const query = 'query';
      final offsetSelected = timeZoneOffsets['CEST'] ?? 0;

      final timeZone = TimeZone(
        location: location.title,
        currentTime: time,
        timezoneAbbreviation: timeZoneApiResponse.timezoneAbbreviation,
        gmtOffset: timeZoneApiResponse.gmtOffset,
        offset: timeZoneApiResponse.gmtOffset - offsetSelected,
      );

      test('returns correct current time', () async {
        final response = await timeZoneRepository.getTimeZoneForLocation(query);
        expect(response, timeZone);
        verify(() => locationApi.locationSearch(query)).called(1);
        verify(() => timeZoneApi.getTimeZone(0, 0)).called(1);
      });

      test('throws NotFoundException if there is an error', () async {
        when(() => locationApi.locationSearch(query)).thenThrow(Exception());
        expect(
          timeZoneRepository.getTimeZoneForLocation(query),
          throwsA(isA<NotFoundException>()),
        );
      });
    });

    group('getTimeZones', () {
      test('returns correct current timezones', () async {
        final response = await timeZoneRepository.getTimeZones();
        expect(
          response,
          isNotNull,
        );
      });

      test('returns empty time zones if cache is empty', () async {
        when(() => storage.read(key: cacheKey)).thenAnswer((_) async => null);
        final response = await timeZoneRepository.getTimeZones();
        expect(response, TimeZones());
      });
    });

    group('addTimeZone', () {
      test('completes', () async {
        expect(
          timeZoneRepository.addTimeZone(
            timeZones.items.first,
            time,
          ),
          completes,
        );
      });

      test('throws DuplicatedTimeZoneException if tryng to add a duplicate',
          () async {
        await timeZoneRepository.addTimeZone(timeZones.items.first, time);
        expect(
          timeZoneRepository.addTimeZone(timeZones.items.first, time),
          throwsA(isA<DuplicatedTimeZoneException>()),
        );
      });
    });

    group('convertTimeZones', () {
      test('completes', () async {
        expect(
          timeZoneRepository.convertTimeZones(
            timeZones,
            DateTime.now(),
          ),
          isNotNull,
        );
      });
    });

    group('deleteTimeZone', () {
      setUp(() async {
        // To load cache first
        await timeZoneRepository.getTimeZones();
      });
      test('completes', () async {
        expect(
          timeZoneRepository.deleteTimeZone(timeZones.items.first),
          isNotNull,
        );
      });

      test('deletes the item', () async {
        final itemToDelete = timeZones.items.first;
        final indexOfItemToDelete =
            timeZoneRepository.timeZones.items.indexWhere(
          (element) => itemToDelete.location == element.location,
        );
        expect(indexOfItemToDelete, isNot(-1));
        await timeZoneRepository.deleteTimeZone(itemToDelete);
        final indexOfItemToDelete1 =
            timeZoneRepository.timeZones.items.indexWhere(
          (element) => itemToDelete.location == element.location,
        );
        expect(indexOfItemToDelete1, -1);
      });
    });
  });
}
