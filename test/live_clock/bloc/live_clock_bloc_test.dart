import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/live_clock/live_clock.dart';

void main() {
  group('LiveClockBloc', () {
    final initialTime = DateTime(2021);
    test('initial state is correct', () {
      final bloc = LiveClockBloc(initialTime);
      expect(bloc.state, LiveClockState(time: initialTime));
    });

    test('increments after timer ends', () {
      fakeAsync(
        (async) {
          final bloc = LiveClockBloc(initialTime);
          const increment = Duration(minutes: 5);
          async.elapse(increment);
          final newTime = initialTime.add(increment);
          expect(bloc.state.time, newTime);
        },
        initialTime: initialTime,
      );
    });
  });
}
