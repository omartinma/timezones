import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_zones_ui/time_zones_ui.dart';

/// {@template live_clock}
/// LiveClock
/// {@endtemplate}
class LiveClock extends StatefulWidget {
  /// Default constructor
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
  _LiveClockState createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late Timer? _timer;
  late DateTime _currentTime;

  @override
  void didUpdateWidget(covariant LiveClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentTime = widget.initialDate;
  }

  @override
  void initState() {
    super.initState();
    _currentTime = widget.initialDate;
    _timer = Timer(
      const Duration(minutes: 1) -
          Duration(
            seconds: _currentTime.second,
            milliseconds: _currentTime.millisecond,
          ),
      _updateTime,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    // Update once per minute
    setState(() {
      _currentTime = _currentTime.add(const Duration(minutes: 1));
      _timer = Timer(const Duration(minutes: 1), _updateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime.toHours(),
      style: widget.textStyle,
    );
  }
}
