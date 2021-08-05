// ignore_for_file: prefer_const_constructors

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
    );
    final timeZone = TimeZone(
      location: location.title,
      currentTime: timeZoneApiResponse.datetime,
      timezoneAbbreviation: timeZoneApiResponse.timezoneAbbreviation,
    );
    const timeZonesJson = '''
{
   "items":[
      {
         "location":"Chicago",
         "currentTime":"2021-08-05T06:08:02.000",
         "timezoneAbbreviation":"CDT"
      }
   ]
}
''';

    final timeZones = TimeZones(items: [timeZone]);

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
      );
    });

    group('getCurrentTimeForLocation', () {
      const query = 'query';
      test('returns correct current time', () async {
        final response =
            await timeZoneRepository.getCurrentTimeForLocation(query);
        expect(response, timeZone);
        verify(() => locationApi.locationSearch(query)).called(1);
        verify(() => timeZoneApi.getTimeZone(0, 0)).called(1);
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
      test('returns correct current timezones', () async {
        final response = await timeZoneRepository.addTimeZone('title');
        expect(response, timeZones);
      });
    });
  });
}
