import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'live_clock_event.dart';
part 'live_clock_state.dart';

class LiveClockBloc extends Bloc<LiveClockEvent, LiveClockState> {
  LiveClockBloc(DateTime time) : super(LiveClockState(time: time));
  Timer? _timer;

  @override
  Stream<LiveClockState> mapEventToState(
    LiveClockEvent event,
  ) async* {
    if (event is LiveClockTimerStarted) {
      final timerDuration = const Duration(minutes: 1) -
          Duration(
            seconds: state.time.second,
            milliseconds: state.time.millisecond,
          );
      _timer = Timer(
        timerDuration,
        () => add(const LiveClockTimerEnded()),
      );
    } else if (event is LiveClockTimerEnded) {
      final newTime = state.time.add(const Duration(minutes: 1) -
          Duration(
            seconds: state.time.second,
            milliseconds: state.time.millisecond,
          ));
      _timer = Timer(
        const Duration(minutes: 1),
        () => add(const LiveClockTimerEnded()),
      );
      yield state.copyWith(time: newTime);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
