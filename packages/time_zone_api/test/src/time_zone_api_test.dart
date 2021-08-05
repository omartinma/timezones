import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:time_zone_api/src/consts/secrets.dart';
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

    group('api key', () {
      test('is not empty', () {
        expect(timeZoneApiKey, isNotEmpty);
      });
    });

    group('getTimeZone', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        const longitude = 0.0;
        const latitude = 0.0;
        try {
          await timeZoneApi.getTimeZone(longitude, latitude);
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

      test('returns TimeZoneApiResponse on valid response', () async {
        final response = MockResponse();
        const jsonResponse = '''
          {
            "datetime": "2020-07-01 14:22:13",
            "timezone_abbreviation": "BST"
          }
          ''';
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(jsonResponse);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        const longitude = 0.0;
        const latitude = 0.0;
        final actualApi = await timeZoneApi.getTimeZone(longitude, latitude);
        final actualJson = TimeZoneApiResponse.fromJson(
          jsonDecode(jsonResponse) as Map<String, dynamic>,
        );
        expect(actualApi.datetime, actualJson.datetime);
        expect(actualApi.timezoneAbbreviation, actualJson.timezoneAbbreviation);
      });
    });
  });
}
