import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_zones_ui/time_zones_ui.dart';

class LiveClock extends StatelessWidget {
  const LiveClock({
    Key? key,
    required DateTime time,
    TextStyle textStyle = const TextStyle(),
  }) : this._(key: key, time: time, textStyle: textStyle);

  /// Constructor for big [LiveClock]
  const LiveClock.big({
    Key? key,
    required DateTime time,
  }) : this._(
          key: key,
          time: time,
          textStyle: const TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );

  /// Constructor for regular [LiveClock]
  const LiveClock.regular({
    Key? key,
    required DateTime time,
  }) : this._(
          key: key,
          time: time,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        );

  const LiveClock._({
    Key? key,
    required this.time,
    required this.textStyle,
  }) : super(key: key);

  /// Initial date to use in the clock.
  final DateTime time;

  /// [TextStyle] to display the current time.
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      time.toHours(),
      style: textStyle,
    );
  }
}
