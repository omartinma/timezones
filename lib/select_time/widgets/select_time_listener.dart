import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/select_time/select_time.dart';

class SelectTimeListener extends StatelessWidget {
  const SelectTimeListener({
    Key? key,
    required this.onTimeChanged,
    required this.onTimeZoneNmaeChanged,
    required this.child,
  }) : super(key: key);

  final ValueSetter<DateTime> onTimeChanged;
  final ValueSetter<String> onTimeZoneNmaeChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SelectTimeBloc, SelectTimeState>(
          listenWhen: (previous, current) =>
              previous.timeSelected != current.timeSelected,
          listener: (context, state) {
            onTimeChanged(state.timeSelected);
          },
        ),
        BlocListener<SelectTimeBloc, SelectTimeState>(
          listenWhen: (previous, current) =>
              previous.timeZoneName != current.timeZoneName,
          listener: (context, state) {
            onTimeZoneNmaeChanged(state.timeZoneName);
          },
        ),
      ],
      child: child,
    );
  }
}
