// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/select_time/select_time.dart';

void main() {
  group('SelectTimeEvent', () {
    group('SelectTimeSelected', () {
      test('supports value comparisons', () {
        final time = DateTime.now();
        final instanceA = SelectTimeSelected(time);
        final instanceB = SelectTimeSelected(time);
        expect(instanceA, instanceB);
      });
    });
    group('SelectTimeTimeZoneNameSelected', () {
      test('supports value comparisons', () {
        final instanceA = SelectTimeTimeZoneNameSelected('CST');
        final instanceB = SelectTimeTimeZoneNameSelected('CST');
        expect(instanceA, instanceB);
      });
    });
  });
}
