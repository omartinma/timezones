import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/time_zones/bloc/time_zones_bloc.dart';

class TimeZonesPage extends StatelessWidget {
  const TimeZonesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeZonesBloc(),
      child: const TimeZonesView(),
    );
  }
}

class TimeZonesView extends StatelessWidget {
  const TimeZonesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<TimeZonesBloc>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text(state.toString()),
      ),
      body: Container(),
    );
  }
}
