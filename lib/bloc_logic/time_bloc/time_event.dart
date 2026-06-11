part of 'time_bloc.dart';

abstract class TimeEvent extends Equatable {
  const TimeEvent();

  get timerStatus => null;

  get dateTime => null;

  get localTimeSlotList => null;

  get context => null;

}

class FetchTime extends TimeEvent {
  @override
  final BuildContext context;
  const FetchTime({required this.context});
  @override
  List<Object?> get props => [];
}
class FetchTodayLastTimeSlot extends TimeEvent {
  @override
  final BuildContext context;
  const FetchTodayLastTimeSlot({required this.context});
  @override
  List<Object?> get props => [];
}
class FetchCurrentMonthChartData extends TimeEvent {
  @override
  final BuildContext context;
  const FetchCurrentMonthChartData({required this.context});
  @override
  List<Object?> get props => [];
}
class AddTimeSlotEvent extends TimeEvent {
  const AddTimeSlotEvent({required this.timerStatus,required this.dateTime,required this.context});
  @override
  final String timerStatus;
  @override
 final  String dateTime;
  @override
  final BuildContext context;
  @override
  List<Object?> get props => [];
}class AddLocalTimeSlotEvent extends TimeEvent {
  const AddLocalTimeSlotEvent({required this.localTimeSlotList,required this.context});
  @override
  final List<Map<String,String>> localTimeSlotList;
  @override
  final BuildContext context;
  @override
   List<Object?> get props => [];
}