import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/live_clock/view/live_clock.dart';
import 'package:timezones/select_time/select_time.dart';

class SelectTimeView extends StatelessWidget {
  const SelectTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SelectTimeBloc, SelectTimeState, DateTime>(
      selector: (state) => state.timeSelected,
      builder: (context, timeSelected) {
        return GestureDetector(
          onTap: () async {
            final bloc = context.read<SelectTimeBloc>();
            final selected = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(timeSelected),
              initialEntryMode: TimePickerEntryMode.input,
            );
            if (selected != null) {
              final now = DateTime.now();
              bloc.add(
                SelectTimeSelected(
                  DateTime(
                    now.year,
                    now.month,
                    now.day,
                    selected.hour,
                    selected.minute,
                  ),
                ),
              );
            }
          },
          child: LiveClock.big(time: timeSelected),
        );
      },
    );
  }
}
