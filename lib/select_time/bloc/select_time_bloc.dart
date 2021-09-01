import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instant/instant.dart';

part 'select_time_event.dart';
part 'select_time_state.dart';

class SelectTimeBloc extends Bloc<SelectTimeEvent, SelectTimeState> {
  SelectTimeBloc(DateTime initialTime)
      : super(SelectTimeState(
          initialTime,
          initialTime.timeZoneName,
        )) {
    final timerDuration = const Duration(minutes: 1) -
        Duration(
          seconds: initialTime.second,
          milliseconds: initialTime.millisecond,
        );
    _timer = Timer(
      timerDuration,
      _onTimerEnded,
    );
  }
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Timer? _timer;
  @override
  Stream<SelectTimeState> mapEventToState(
    SelectTimeEvent event,
  ) async* {
    if (event is SelectTimeSelected) {
      yield state.copyWith(timeSelected: event.time);
    } else if (event is SelectTimeTimeZoneNameSelected) {
      final currentTime = curDateTimeByZone(zone: event.timeZoneName);
      yield state.copyWith(
        timeZoneName: event.timeZoneName,
        timeSelected: currentTime,
      );
    }
  }

  void _onTimerEnded() {
    final newTime = state.timeSelected.add(const Duration(minutes: 1) -
        Duration(
          seconds: state.timeSelected.second,
          milliseconds: state.timeSelected.millisecond,
        ));
    _timer = Timer(
      const Duration(minutes: 1),
      _onTimerEnded,
    );
    this.add(SelectTimeSelected(newTime));
  }
}
