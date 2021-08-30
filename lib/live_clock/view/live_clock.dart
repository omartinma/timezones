import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_zones_ui/time_zones_ui.dart';
import 'package:timezones/live_clock/live_clock.dart';

class LiveClock extends StatelessWidget {
  const LiveClock({
    Key? key,
    required DateTime initialDate,
    TextStyle textStyle = const TextStyle(),
  }) : this._(key: key, initialDate: initialDate, textStyle: textStyle);

  /// Constructor for big [LiveClock]
  const LiveClock.big({
    Key? key,
    required DateTime initialDate,
  }) : this._(
          key: key,
          initialDate: initialDate,
          textStyle: const TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );

  /// Constructor for regular [LiveClock]
  const LiveClock.regular({
    Key? key,
    required DateTime initialDate,
  }) : this._(
          key: key,
          initialDate: initialDate,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        );

  const LiveClock._({
    Key? key,
    required this.initialDate,
    required this.textStyle,
  }) : super(key: key);

  /// Initial date to use in the clock.
  final DateTime initialDate;

  /// [TextStyle] to display the current time.
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LiveClockBloc(initialDate)..add(const LiveClockTimerStarted()),
      child: Builder(
        builder: (context) {
          return LiveClockView(
            textStyle: textStyle,
          );
        },
      ),
    );
  }
}

class LiveClockView extends StatelessWidget {
  const LiveClockView({Key? key, required this.textStyle}) : super(key: key);

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveClockBloc, LiveClockState>(
      builder: (context, state) {
        return Text(
          state.time.toHours(),
          style: textStyle,
        );
      },
    );
  }
}
