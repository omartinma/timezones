import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

part 'time_zones_event.dart';
part 'time_zones_state.dart';

class TimeZonesBloc extends Bloc<TimeZonesEvent, TimeZonesState> {
  TimeZonesBloc({required TimeZoneRepository timeZoneRepository})
      : _timeZoneRepository = timeZoneRepository,
        super(const TimeZonesState(status: TimeZonesStatus.loading));

  final TimeZoneRepository _timeZoneRepository;

  @override
  Stream<TimeZonesState> mapEventToState(
    TimeZonesEvent event,
  ) async* {
    if (event is TimeZonesFetchRequested) {
      yield* _mapTimeZonesFetchRequestedToState(event);
    }
  }

  Stream<TimeZonesState> _mapTimeZonesFetchRequestedToState(
    TimeZonesFetchRequested event,
  ) async* {
    yield state.copyWith(status: TimeZonesStatus.loading);
    try {
      final timeZone = await _timeZoneRepository.getTimeZones();
      yield state.copyWith(
        status: TimeZonesStatus.populated,
        timeZones: timeZone,
      );
    } catch (e, st) {
      yield state.copyWith(status: TimeZonesStatus.error);
      addError(e, st);
    }
  }
}
