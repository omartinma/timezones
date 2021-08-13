import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

part 'time_zones_event.dart';
part 'time_zones_state.dart';

class TimeZonesBloc extends Bloc<TimeZonesEvent, TimeZonesState> {
  TimeZonesBloc({
    required TimeZoneRepository timeZoneRepository,
  })  : _timeZoneRepository = timeZoneRepository,
        super(TimeZonesState(timeSelected: DateTime.now()));

  final TimeZoneRepository _timeZoneRepository;

  @override
  Stream<TimeZonesState> mapEventToState(
    TimeZonesEvent event,
  ) async* {
    if (event is TimeZonesFetchRequested) {
      yield* _mapTimeZonesFetchRequestedToState();
    } else if (event is TimeZonesAddRequested) {
      yield* _mapTimeZonesAddRequestedToState(event);
    } else if (event is TimeZonesTimeSelected) {
      yield* _mapTimeZonesTimeSelectedToState(event);
    } else if (event is TimeZonesDeleteRequested) {
      yield* _mapTimeZonesDeleteRequestedToState(event);
    }
  }

  Stream<TimeZonesState> _mapTimeZonesFetchRequestedToState() async* {
    yield state.copyWith(status: TimeZonesStatus.loading);
    try {
      final timeZone = await _timeZoneRepository.getTimeZones();
      yield state.copyWith(
        status: TimeZonesStatus.populated,
        timeZones: timeZone,
        timeSelected: DateTime.now(),
      );
    } catch (e, st) {
      yield state.copyWith(status: TimeZonesStatus.error);
      addError(e, st);
    }
  }

  Stream<TimeZonesState> _mapTimeZonesAddRequestedToState(
    TimeZonesAddRequested event,
  ) async* {
    yield state.copyWith(status: TimeZonesStatus.loading);
    try {
      final timeZone =
          await _timeZoneRepository.getTimeZoneForLocation(event.city);
      final timeZones = await _timeZoneRepository.addTimeZone(
        timeZone,
        state.timeSelected!,
      );
      yield state.copyWith(
        status: TimeZonesStatus.populated,
        timeZones: timeZones,
      );
    } on DuplicatedTimeZoneException {
      yield state.copyWith(
        errorAddingStatus: ErrorAddingStatus.duplicated,
        status: TimeZonesStatus.populated,
      );
    } on NotFoundException {
      yield state.copyWith(
        errorAddingStatus: ErrorAddingStatus.notFound,
        status: TimeZonesStatus.populated,
      );
    }
  }

  Stream<TimeZonesState> _mapTimeZonesTimeSelectedToState(
    TimeZonesTimeSelected event,
  ) async* {
    final newTimeZones = _timeZoneRepository.convertTimeZones(
      state.timeZones,
      event.time,
    );
    yield state.copyWith(
      timeSelected: event.time,
      timeZones: newTimeZones,
    );
  }

  Stream<TimeZonesState> _mapTimeZonesDeleteRequestedToState(
    TimeZonesDeleteRequested event,
  ) async* {
    final newTimeZones =
        await _timeZoneRepository.deleteTimeZone(event.timeZone);

    yield state.copyWith(
      timeZones: newTimeZones,
    );
  }
}
