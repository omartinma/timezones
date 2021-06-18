import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timezones_event.dart';
part 'timezones_state.dart';

class TimezonesBloc extends Bloc<TimezonesEvent, TimezonesState> {
  TimezonesBloc() : super(TimezonesInitial());

  @override
  Stream<TimezonesState> mapEventToState(
    TimezonesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
