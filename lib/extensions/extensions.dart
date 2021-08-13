import 'package:intl/intl.dart';

extension TimeConverter on DateTime {
  String toHours() {
    final hour = DateFormat.Hm().format(this);
    return hour;
  }
}
