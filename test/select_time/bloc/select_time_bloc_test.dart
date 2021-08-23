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
          SelectTimeState(time),
        ],
      );
    });
  });
}
