import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instant/instant.dart';

part 'select_time_event.dart';
part 'select_time_state.dart';

class SelectTimeBloc extends Bloc<SelectTimeEvent, SelectTimeState> {
  SelectTimeBloc()
      : super(SelectTimeState(
          DateTime.now(),
          DateTime.now().timeZoneName,
        )) {
    on<SelectTimeSelected>(_onTimeSelected);
    on<SelectTimeTimeZoneNameSelected>(_onTimeZoneNameSelected);
  }

  void _onTimeSelected(
    SelectTimeSelected event,
    Emitter<SelectTimeState> emit,
  ) {
    emit(state.copyWith(timeSelected: event.time));
  }

  FutureOr<void> _onTimeZoneNameSelected(
      SelectTimeTimeZoneNameSelected event, Emitter<SelectTimeState> emit) {
    final currentTime = curDateTimeByZone(zone: event.timeZoneName);
    emit(
      state.copyWith(
        timeZoneName: event.timeZoneName,
        timeSelected: currentTime,
      ),
    );
  }
}
