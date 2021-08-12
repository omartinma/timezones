import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: Text(timeZone.location),
        trailing: Text(timeZone.currentTime.toHours()),
      ),
    );
  }
}

extension TimeConverter on DateTime {
  String toHours() {
    final hour = DateFormat.Hm().format(this);
    return hour;
  }
}
