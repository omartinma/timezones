// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/select_time/select_time.dart';

void main() {
  group('SelectTimeBloc', () {
    group('SelectTimeSelected', () {
      final time = DateTime.now();
      blocTest<SelectTimeBloc, SelectTimeState>(
        'emits state with new time',
        build: () => SelectTimeBloc(),
        act: (bloc) => bloc.add(SelectTimeSelected(time)),
        expect: () => [
          SelectTimeState(time, time.timeZoneName),
        ],
      );
    });

    group('SelectTimeTimeZoneNameSelected', () {
      blocTest<SelectTimeBloc, SelectTimeState>(
        'emits state with new time zone name',
        build: () => SelectTimeBloc(),
        act: (bloc) => bloc.add(SelectTimeTimeZoneNameSelected('CEST')),
        expect: () => [
          isA<SelectTimeState>()
              .having((l) => l.timeZoneName, 'timeZoneName', 'CEST')
        ],
      );
    });
  });
}
