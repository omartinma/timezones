import 'package:test/test.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

void main() {
  group('TimeZone', () {
    test('supports JSON serialization', () {
      final timeZone1 = TimeZone(
        location: 'location',
        currentTime: DateTime.now(),
        timezoneAbbreviation: 'timezoneAbbreviation',
      );

      final timeZone2 = TimeZone.fromJson(timeZone1.toJson());
      expect(timeZone1, equals(timeZone2));
    });
  });
}
