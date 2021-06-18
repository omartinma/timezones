import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/timezones/timezones.dart';

class TimeZonesPage extends StatelessWidget {
  const TimeZonesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimezonesBloc(),
      child: const _TimeZonesView(),
    );
  }
}

class _TimeZonesView extends StatelessWidget {
  const _TimeZonesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
