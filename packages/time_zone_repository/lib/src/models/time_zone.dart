import 'package:equatable/equatable.dart';

/// TimeZone
class TimeZone extends Equatable {
  /// Constructor for TimeZone
  const TimeZone({
    required this.location,
    required this.currentTime,
  });

  /// Location name
  final String location;

  /// Current time for the location
  final DateTime currentTime;

  @override
  List<Object> get props => [location, currentTime];
}
