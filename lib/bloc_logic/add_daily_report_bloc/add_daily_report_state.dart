part of 'add_daily_report_bloc.dart';

abstract class AddDailyReportState extends Equatable {
  const AddDailyReportState();
}

class AddDailyReportInitial extends AddDailyReportState {
  @override
  List<Object> get props => [];
}

class AddDailyReportLoading extends AddDailyReportState {
  @override
  List<Object> get props => [];
}

class AddDailyReportLoaded extends AddDailyReportState {
  const AddDailyReportLoaded({this.data});
  final DailyReportModel? data;
  @override
  List<Object> get props => [data!];
}

class AddDailyReportError extends AddDailyReportState {
  const AddDailyReportError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}