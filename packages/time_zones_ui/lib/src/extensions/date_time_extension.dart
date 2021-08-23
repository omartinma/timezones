import 'package:intl/intl.dart';

/// Extenstion for [DateTime]
extension TimeConverter on DateTime {
  /// Display in hours
  String toHours() {
    final hour = DateFormat.Hm().format(this);
    return hour;
  }
}
