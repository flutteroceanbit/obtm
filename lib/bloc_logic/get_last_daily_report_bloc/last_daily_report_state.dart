part of 'last_daily_report_bloc.dart';

abstract class LastDailyReportState extends Equatable{
  @override
  List<Object?> get props => [];
}

class GetLastDailyReportInitial extends LastDailyReportState{
  @override
  List<Object?> get props => [];
}

class GetLastDailyReportLoading extends LastDailyReportState {
  @override
  List<Object> get props => [];
}

class GetLastDailyReportLoaded extends LastDailyReportState {
  GetLastDailyReportLoaded({this.data});
  final DailyReportModel? data;
  @override
  List<Object> get props => [data!];
}

class GetLastDailyReportError extends LastDailyReportState {
  GetLastDailyReportError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
