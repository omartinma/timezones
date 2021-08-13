import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/time_zones/time_zones.dart';
import 'package:timezones/extensions/extensions.dart';

class SelectTimeView extends StatelessWidget {
  const SelectTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final bloc = context.read<TimeZonesBloc>();
        final currentSelected = bloc.state.timeSelected;
        final selected = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentSelected!),
          initialEntryMode: TimePickerEntryMode.input,
        );
        if (selected != null) {
          final now = DateTime.now();
          bloc.add(
            TimeZonesTimeSelected(
              time: DateTime(
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
      child: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Time Selected'),
            BlocSelector<TimeZonesBloc, TimeZonesState, DateTime?>(
              selector: (state) => state.timeSelected,
              builder: (context, state) => Text(state?.toHours() ?? ''),
            )
          ],
        ),
      ),
    );
  }
}
