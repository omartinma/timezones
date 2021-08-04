import 'package:flutter/material.dart';
import 'package:timezones/l10n/l10n.dart';

class TimeZonesEmptyView extends StatelessWidget {
  const TimeZonesEmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(child: Text(l10n.emptyPageMessage));
  }
}
