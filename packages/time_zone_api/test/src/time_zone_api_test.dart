import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:time_zone_api/time_zone_api.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('TimeZoneApi', () {
    late http.Client httpClient;
    late TimeZoneApi timeZoneApi;

    setUpAll(() {
      registerFallbackValue<Uri>(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      timeZoneApi = TimeZoneApi(httpClient: httpClient, apiKey: 'X');
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(TimeZoneApi(), isNotNull);
      });
    });

    group('getCurrentTime', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        const longitude = 0.0;
        const latitude = 0.0;
        try {
          await timeZoneApi.getCurrentTime(longitude, latitude);
        } catch (_) {}
        verify(
          () => httpClient.get(Uri.https(
            'timezone.abstractapi.com',
            'v1/current_time',
            <String, String>{
              'api_key': 'X',
              'location': '$longitude,$latitude',
            },
          )),
        ).called(1);
      });

      test('returns DateTime on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''{
            "datetime": "2020-07-01 14:22:13"
          }''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        const longitude = 0.0;
        const latitude = 0.0;
        final actual = await timeZoneApi.getCurrentTime(longitude, latitude);
        expect(actual, isA<DateTime>().having((l) => l.year, 'year', 2020));
      });
    });
  });
}
