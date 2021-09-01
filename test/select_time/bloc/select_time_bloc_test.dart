// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/select_time/select_time.dart';

void main() {
  group('SelectTimeBloc', () {
    final time = DateTime(2021);

    test('increments after timer ends', () {
      fakeAsync(
        (async) {
          final bloc = SelectTimeBloc(time);
          const increment = Duration(minutes: 5);
          async.elapse(increment);
          final newTime = time.add(increment);
          expect(bloc.state.timeSelected, newTime);
        },
        initialTime: time,
      );
    });

    group('SelectTimeSelected', () {
      blocTest<SelectTimeBloc, SelectTimeState>(
        'emits state with new time',
        build: () => SelectTimeBloc(time),
        act: (bloc) => bloc.add(SelectTimeSelected(time)),
        expect: () => [
          SelectTimeState(time, time.timeZoneName),
        ],
      );
    });

    group('SelectTimeTimeZoneNameSelected', () {
      blocTest<SelectTimeBloc, SelectTimeState>(
        'emits state with new time zone name',
        build: () => SelectTimeBloc(time),
        act: (bloc) => bloc.add(SelectTimeTimeZoneNameSelected('CEST')),
        expect: () => [
          isA<SelectTimeState>()
              .having((l) => l.timeZoneName, 'timeZoneName', 'CEST')
        ],
      );
    });
  });
}
