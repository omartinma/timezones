import 'package:flutter/material.dart';
import 'package:timezones/time_zones/time_zones.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () async =>
          context.read<TimeZonesBloc>().add(const TimeZonesFetchRequested()),
      child: const Icon(Icons.refresh),
    );
  }
}
