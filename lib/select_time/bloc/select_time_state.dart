part of 'select_time_bloc.dart';

class SelectTimeState extends Equatable {
  const SelectTimeState(
    this.timeSelected,
  );

  final DateTime timeSelected;

  @override
  List<Object> get props => [timeSelected];
}
