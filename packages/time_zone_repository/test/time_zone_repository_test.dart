// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

void main() {
  group('TimeZoneRepository', () {
    test('can be instantiated', () {
      expect(TimeZoneRepository(), isNotNull);
    });
  });
}
