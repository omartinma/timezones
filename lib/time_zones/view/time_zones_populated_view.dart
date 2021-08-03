import 'package:flutter/material.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/time_zones/time_zones.dart';

class TimeZonesPopulatedView extends StatelessWidget {
  const TimeZonesPopulatedView({
    Key? key,
    required this.timeZones,
  }) : super(key: key);

  final List<TimeZone> timeZones;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => TimeZoneTile(timeZone: timeZones[index]),
      itemCount: timeZones.length,
    );
  }
}
