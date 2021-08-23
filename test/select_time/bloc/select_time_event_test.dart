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
  });
}
