import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/live_clock/live_clock.dart';

void main() {
  group('LiveClockBloc', () {
    final initialTime = DateTime(2021);
    test('initial state is correct', () {
      final bloc = LiveClockBloc(initialTime);
      expect(bloc.state, LiveClockState(time: initialTime));
    });
  });
}
