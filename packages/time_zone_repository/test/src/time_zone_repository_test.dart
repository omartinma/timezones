// ignore_for_file: prefer_const_constructors
import 'package:location_api/location_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:time_zone_api/time_zone_api.dart';
import 'package:time_zone_repository/src/models/time_zone.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

class MockTimeZoneApi extends Mock implements TimeZoneApi {}

class MockLocationApi extends Mock implements LocationApi {}

void main() {
  group('TimeZoneRepository', () {
    late TimeZoneRepository timeZoneRepository;
    late TimeZoneApi timeZoneApi;
    late LocationApi locationApi;
    final location = Location(
      title: 'title',
      latLng: LatLng(latitude: 0, longitude: 0),
      woeid: 0,
    );
    final time = DateTime.now();
    final timeZone = TimeZone(location: location.title, currentTime: time);

    setUp(() {
      timeZoneApi = MockTimeZoneApi();
      locationApi = MockLocationApi();
      when(() => timeZoneApi.getCurrentTime(any(), any())).thenAnswer(
        (_) async => time,
      );
      when(() => locationApi.locationSearch(any())).thenAnswer(
        (_) async => location,
      );
      timeZoneRepository = TimeZoneRepository(
        timeZoneApi: timeZoneApi,
        locationApi: locationApi,
      );
    });

    group('getCurrentTimeForLocation', () {
      const query = 'query';
      test('returns correct current time', () async {
        final response =
            await timeZoneRepository.getCurrentTimeForLocation(query);
        expect(response, timeZone);
        verify(() => locationApi.locationSearch(query)).called(1);
        verify(() => timeZoneApi.getCurrentTime(0.0, 0)).called(1);
      });
    });
  });
}
