part of 'select_time_bloc.dart';

class SelectTimeState extends Equatable {
  const SelectTimeState(
    this.timeSelected,
    this.timeZoneName,
  );

  final DateTime timeSelected;
  final String timeZoneName;

  @override
  List<Object> get props => [timeSelected, timeZoneName];

  SelectTimeState copyWith({
    DateTime? timeSelected,
    String? timeZoneName,
  }) {
    return SelectTimeState(
      timeSelected ?? this.timeSelected,
      timeZoneName ?? this.timeZoneName,
    );
  }
}
