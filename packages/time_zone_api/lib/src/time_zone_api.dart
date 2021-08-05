import 'dart:convert';

import 'package:http/http.dart';
import 'package:time_zone_api/src/consts/secrets.dart';
import 'package:time_zone_api/time_zone_api.dart';

/// {@template time_zone_api}
/// Time Zone API
/// {@endtemplate}
class TimeZoneApi {
  /// {@macro time_zone_api}

  TimeZoneApi({Client? httpClient, String? apiKey})
      : _httpClient = httpClient ?? Client(),
        _apiKey = apiKey ?? timeZoneApiKey;

  static const _baseUrl = 'timezone.abstractapi.com';
  static const _currentTimeEndpoint = 'v1/current_time';
  final Client _httpClient;
  final String _apiKey;

  /// Get current time for a given longitude and latitude
  Future<TimeZoneApiResponse> getTimeZone(
    double longitude,
    double latitude,
  ) async {
    final currentTimeRequest = Uri.https(
      _baseUrl,
      _currentTimeEndpoint,
      <String, String>{
        'api_key': _apiKey,
        'location': '$latitude,$longitude',
      },
    );
    final response = await _httpClient.get(currentTimeRequest);
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return TimeZoneApiResponse.fromJson(responseJson);
  }
}
