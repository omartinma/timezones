import 'package:flutter/material.dart';

class TimeZonesLoadingView extends StatelessWidget {
  const TimeZonesLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
