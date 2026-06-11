part of 'get_daily_report_bloc.dart';

abstract class GetDailyReportState extends Equatable {
  const GetDailyReportState();
}

class GetDailyReportInitial extends GetDailyReportState {
  @override
  List<Object> get props => [];
}

class GetDailyReportLoading extends GetDailyReportState {
  @override
  List<Object> get props => [];
}

class GetDailyReportLoaded extends GetDailyReportState {
  const GetDailyReportLoaded({this.data});
  final GetDailyReportModel? data;
  @override
  List<Object> get props => [data!];
}

class GetDailyReportError extends GetDailyReportState {
  const GetDailyReportError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class GetMonthlyReportInitial extends GetDailyReportState {
  @override
  List<Object?> get props => [];
}

class GetMonthlyReportLoading extends GetDailyReportState {
  @override
  List<Object?> get props => [];
}

class GetMonthlyReportLoaded extends GetDailyReportState {
  final GetDailyReportModel? data;
  const GetMonthlyReportLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class GetMonthlyReportError extends GetDailyReportState {
  final dynamic errors;
  const GetMonthlyReportError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
