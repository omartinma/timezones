import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

class TimeZoneTile extends StatelessWidget {
  const TimeZoneTile({Key? key, required this.timeZone}) : super(key: key);

  final TimeZone timeZone;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(timeZone.location),
      trailing: Text(timeZone.currentTime.toHours()),
    );
  }
}

extension TimeConverter on DateTime {
  String toHours() {
    final hour = DateFormat.Hm().format(this);
    return hour;
  }
}
