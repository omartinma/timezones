import 'dart:convert';

import 'package:http/http.dart';

import 'consts/consts.dart';

/// {@template time_zone_api}
/// Time Zone API
/// {@endtemplate}
class TimeZoneApi {
  /// {@macro time_zone_api}

  TimeZoneApi({Client? httpClient}) : _httpClient = httpClient ?? Client();

  static const _baseUrl = 'timezone.abstractapi.com';
  static const _currentTimeEndpoint = 'v1/current_time';
  final Client _httpClient;

  /// Get current time for a given longitude and latitude
  Future<DateTime> getCurrentTime(double longitude, double latitude) async {
    final currentTimeRequest = Uri.https(
      _baseUrl,
      _currentTimeEndpoint,
      <String, String>{
        'api_key': timeZoneApiKey,
        'location': '$longitude,$latitude',
      },
    );
    final response = await _httpClient.get(currentTimeRequest);
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return DateTime.parse(responseJson['datetime']);
  }
}
