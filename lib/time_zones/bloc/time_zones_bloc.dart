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
        super(
          TimeZonesState(
            timeSelected: DateTime.now(),
            timeZoneName: DateTime.now().timeZoneName,
          ),
        ) {
    on<TimeZonesFetchRequested>(_fetchRequested);
    on<TimeZonesAddRequested>(_addRequested);
    on<TimeZonesTimeSelected>(_timeSelected);
    on<TimeZonesDeleteRequested>(_deleteRequested);
    on<TimeZonesTimeZoneNameSelected>(_timeZoneNameSelected);
  }

  final TimeZoneRepository _timeZoneRepository;

  Future<FutureOr<void>> _fetchRequested(
    TimeZonesFetchRequested event,
    Emitter<TimeZonesState> emit,
  ) async {
    emit(state.copyWith(status: TimeZonesStatus.loading));
    try {
      final timeZones = await _timeZoneRepository.getTimeZones();
      emit(
        state.copyWith(
          status: TimeZonesStatus.populated,
          timeZones: timeZones,
          timeSelected: DateTime.now(),
        ),
      );
    } catch (e, st) {
      emit(state.copyWith(status: TimeZonesStatus.error));
      addError(e, st);
    }
  }

  FutureOr<void> _addRequested(
      TimeZonesAddRequested event, Emitter<TimeZonesState> emit) async {
    emit(state.copyWith(status: TimeZonesStatus.loading));
    try {
      final timeZone =
          await _timeZoneRepository.getTimeZoneForLocation(event.city);
      final timeZones = await _timeZoneRepository.addTimeZone(
        timeZone,
        state.timeSelected!,
      );
      emit(
        state.copyWith(
          status: TimeZonesStatus.populated,
          timeZones: timeZones,
        ),
      );
    } on DuplicatedTimeZoneException {
      emit(
        state.copyWith(
          errorAddingStatus: ErrorAddingStatus.duplicated,
          status: TimeZonesStatus.populated,
        ),
      );
    } on NotFoundException {
      emit(
        state.copyWith(
          errorAddingStatus: ErrorAddingStatus.notFound,
          status: TimeZonesStatus.populated,
        ),
      );
    }
  }

  FutureOr<void> _timeSelected(
      TimeZonesTimeSelected event, Emitter<TimeZonesState> emit) {
    final newTimeZones = _timeZoneRepository.convertTimeZones(
      state.timeZones,
      event.time,
    );
    emit(
      state.copyWith(
        timeSelected: event.time,
        timeZones: newTimeZones,
      ),
    );
  }

  FutureOr<void> _deleteRequested(
      TimeZonesDeleteRequested event, Emitter<TimeZonesState> emit) async {
    final newTimeZones =
        await _timeZoneRepository.deleteTimeZone(event.timeZone);

    emit(state.copyWith(timeZones: newTimeZones));
  }

  FutureOr<void> _timeZoneNameSelected(
      TimeZonesTimeZoneNameSelected event, Emitter<TimeZonesState> emit) {
    _timeZoneRepository.timeZoneNameSelected = event.timeZoneName;
    final currentTimeSelected = state.timeSelected ?? DateTime.now();
    final convertedTimeZones = _timeZoneRepository.convertTimeZones(
      state.timeZones,
      currentTimeSelected,
    );
    emit(
      state.copyWith(
        timeZones: convertedTimeZones,
        timeZoneName: event.timeZoneName,
      ),
    );
  }
}
