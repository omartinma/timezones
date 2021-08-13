import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/select_time/select_time.dart';

class SelectTimeListener extends StatelessWidget {
  const SelectTimeListener({
    Key? key,
    required this.onTimeChanged,
    required this.child,
  }) : super(key: key);

  final ValueSetter<DateTime> onTimeChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectTimeBloc, SelectTimeState>(
      listener: (context, state) {
        onTimeChanged(state.timeSelected);
      },
      child: child,
    );
  }
}
