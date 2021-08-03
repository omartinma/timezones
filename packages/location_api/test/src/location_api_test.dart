import 'package:http/http.dart' as http;
import 'package:location_api/location_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('LocationApi', () {
    late http.Client httpClient;
    late LocationApi locationApi;
    setUpAll(() {
      registerFallbackValue<Uri>(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      locationApi = LocationApi(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(LocationApi(), isNotNull);
      });
    });

    group('locationSearch', () {
      const query = 'mock-query';
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await locationApi.locationSearch(query);
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https(
              'www.metaweather.com',
              '/api/location/search',
              <String, String>{'query': query},
            ),
          ),
        ).called(1);
      });

      test('throws LocationIdRequestFailure on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => locationApi.locationSearch(query),
          throwsA(isA<LocationIdRequestFailure>()),
        );
      });

      test('throws LocationNotFoundFailure on empty response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          locationApi.locationSearch(query),
          throwsA(isA<LocationNotFoundFailure>()),
        );
      });

      test('returns Location on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
          [{
            "title": "mock-title",
            "location_type": "City",
            "latt_long": "-34.75,83.28",
            "woeid": 42
          }]''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await locationApi.locationSearch(query);
        expect(
          actual,
          isA<Location>()
              .having((l) => l.title, 'title', 'mock-title')
              .having(
                (l) => l.latLng,
                'latLng',
                isA<LatLng>()
                    .having((c) => c.latitude, 'latitude', -34.75)
                    .having((c) => c.longitude, 'longitude', 83.28),
              )
              .having((l) => l.woeid, 'woeid', 42),
        );
      });
    });
  });
}
