import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/live_clock/live_clock.dart';
import 'package:timezones/time_zones/time_zones.dart';

class TimeZoneTile extends StatelessWidget {
  const TimeZoneTile({Key? key, required this.timeZone}) : super(key: key);

  final TimeZone timeZone;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            context
                .read<TimeZonesBloc>()
                .add(TimeZonesDeleteRequested(timeZone: timeZone));
          },
        ),
      ],
      child: ListTile(
        title: Text(
          timeZone.location,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            LiveClock.regular(initialDate: timeZone.currentTime),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(timeZone.timezoneAbbreviation),
                if (timeZone.offset != 0) ...[
                  const SizedBox(width: 5),
                  TimeZoneOffset(
                    offset: timeZone.offset,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeZoneOffset extends StatelessWidget {
  const TimeZoneOffset({Key? key, required this.offset}) : super(key: key);

  final double offset;
  @override
  Widget build(BuildContext context) {
    if (offset == 0) return const SizedBox();
    final offsetSign = offset.isNegative ? '' : '+';
    return Text('$offsetSign${offset.toInt()} hrs');
  }
}
