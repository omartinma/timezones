import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/select_time/select_time.dart';

void main() {
  group('SelectTimeState', () {
    test('supports value comparisons', () {
      final time = DateTime.now();
      final instanceA = SelectTimeState(time, time.timeZoneName);
      final instanceB = instanceA.copyWith();
      expect(instanceA, instanceB);
    });
  });
}
