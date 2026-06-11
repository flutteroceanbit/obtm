part of 'time_bloc.dart';

abstract class TimeState extends Equatable {
  const TimeState();
}

class TimeInitial extends TimeState {
  @override
  List<Object> get props => [];
}

/// add timeslot
class AddTimeSlotLoading extends TimeState {
  @override
  List<Object> get props => [];
}

class AddTimeSlotLoaded extends TimeState {
  const AddTimeSlotLoaded({this.data});
  final AddTimeSlotModel? data;
  @override
  List<Object> get props => [data!];
}

class AddTimeSlotError extends TimeState {
  const AddTimeSlotError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

/// add local timeslot
class AddLocalTimeSlotLoading extends TimeState {
  @override
  List<Object> get props => [];
}

class AddLocalTimeSlotLoaded extends TimeState {
  const AddLocalTimeSlotLoaded({this.data});
  final List<AddLocalTimeSlotModel>? data;
  @override
  List<Object> get props => [data!];
}

class AddLocalTimeSlotError extends TimeState {
  const AddLocalTimeSlotError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

/// get all time slot data
class GetTimeSlotLoading extends TimeState {
  @override
  List<Object> get props => [];
}

class GetTimeSlotLoaded extends TimeState {
  const GetTimeSlotLoaded({this.data});
  final GetAllTimeSlotModel? data;
  @override
  List<Object> get props => [data!];
}

class GetTimeSlotError extends TimeState {
  const GetTimeSlotError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

/// get today last time slot data
class GetLastTimeSlotLoading extends TimeState {
  @override
  List<Object> get props => [];
}

class GetLastTimeSlotLoaded extends TimeState {
  const GetLastTimeSlotLoaded({this.data});
  final AddTimeSlotModel? data;
  @override
  List<Object> get props => [data!];
}

class GetLastTimeSlotError extends TimeState {
  const GetLastTimeSlotError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

/// get current month chart data
class GetCurrentMonthChartDataLoading extends TimeState {
  @override
  List<Object> get props => [];
}

class GetCurrentMonthChartDataLoaded extends TimeState {
  const GetCurrentMonthChartDataLoaded({this.data});
  final ChartMonthDataModel? data;
  @override
  List<Object> get props => [data!];
}

class GetCurrentMonthChartDataError extends TimeState {
  const GetCurrentMonthChartDataError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
