import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/time_zones/time_zones.dart';

class TimeZonesPage extends StatelessWidget {
  const TimeZonesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TimeZonesBloc(timeZoneRepository: context.read<TimeZoneRepository>())
            ..add(const TimeZonesFetchRequested(query: 'madrid')),
      child: const TimeZonesView(),
    );
  }
}

class TimeZonesView extends StatelessWidget {
  const TimeZonesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<TimeZonesBloc, TimeZonesState>(
      builder: (context, state) {
        switch (state.status) {
          case TimeZonesStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case TimeZonesStatus.error:
            return const Center(
              child: Text('Not found'),
            );
          case TimeZonesStatus.populated:
            return TimeZonesPopulatedView(timeZone: state.timeZone!);
        }
      },
    ));
  }
}
