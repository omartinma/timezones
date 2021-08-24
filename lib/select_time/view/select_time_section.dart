import 'package:flutter/material.dart';
import 'package:timezones/select_time/select_time.dart';

class SelectTimeSection extends StatelessWidget {
  const SelectTimeSection({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade900,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            SelectTimeView(),
            SizedBox(
              width: 10,
            ),
            SelectTimeZoneName(),
          ],
        ),
      ),
    );
  }
}
