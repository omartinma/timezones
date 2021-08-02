import 'package:flutter/material.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

class TimeZonesPopulatedView extends StatelessWidget {
  const TimeZonesPopulatedView({
    Key? key,
    required this.timeZone,
  }) : super(key: key);

  final TimeZone timeZone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(timeZone.location),
          Text(timeZone.currentTime.toString()),
        ],
      ),
    );
  }
}
