import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/live_clock/bloc/live_clock_bloc.dart';

void main() {
  group('LiveClockState', () {
    test('supports value comparison', () {
      final time = DateTime.now();
      final instanceA = LiveClockState(time: time);
      final instanceB = LiveClockState(time: time);
      expect(instanceA, equals(instanceB));
    });

    test('copyWith', () {
      final time = DateTime.now();
      final instanceA = LiveClockState(time: time);
      final instanceB = instanceA.copyWith();
      expect(instanceA, equals(instanceB));
    });
  });
}
