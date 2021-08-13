import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'select_time_event.dart';
part 'select_time_state.dart';

class SelectTimeBloc extends Bloc<SelectTimeEvent, SelectTimeState> {
  SelectTimeBloc() : super(SelectTimeState(DateTime.now()));

  @override
  Stream<SelectTimeState> mapEventToState(
    SelectTimeEvent event,
  ) async* {
    if (event is SelectTimeSelected) {
      yield SelectTimeState(event.time);
    }
  }
}
