import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_zones_ui/time_zones_ui.dart';
import 'package:timezones/select_time/select_time.dart';

class SelectTimeSection extends StatelessWidget {
  const SelectTimeSection({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade900,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BlocSelector<SelectTimeBloc, SelectTimeState, DateTime>(
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
                  child: LiveClock.big(initialDate: timeSelected),
                );
              },
            ),
            const SizedBox(
              width: 10,
            ),
            const SelectTimeZoneName(),
          ],
        ),
      ),
    );
  }
}
