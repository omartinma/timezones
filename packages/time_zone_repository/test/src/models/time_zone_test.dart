import 'package:test/test.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

void main() {
  group('TimeZone', () {
    test('supports JSON serialization', () {
      final timeZone1 = TimeZone(
        location: 'location',
        currentTime: DateTime.now(),
        timezoneAbbreviation: 'timezoneAbbreviation',
        gmtOffset: 0,
        offset: 0,
      );

      final timeZone2 = TimeZone.fromJson(timeZone1.toJson());
      expect(timeZone1, equals(timeZone2));
    });

    test('copyWith', () {
      final timeZone1 = TimeZone(
        location: 'location',
        currentTime: DateTime.now(),
        timezoneAbbreviation: 'timezoneAbbreviation',
        gmtOffset: 0,
        offset: 0,
      );

      final timeZone2 = timeZone1.copyWith();
      expect(timeZone1, equals(timeZone2));
    });
  });
}
