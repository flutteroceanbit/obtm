part of 'monthly_report_bloc.dart';

abstract class MonthlyReportState extends Equatable {
  const MonthlyReportState();
}

class MonthlyReportInitial extends MonthlyReportState {
  @override
  List<Object> get props => [];
}

class MonthlyReportLoading extends MonthlyReportState {
  @override
  List<Object> get props => [];
}

class MonthlyReportLoaded extends MonthlyReportState {
  const MonthlyReportLoaded({this.data});
  final GetDailyReportModel? data;
  @override
  List<Object> get props => [data!];
}

class MonthlyReportError extends MonthlyReportState {
  const MonthlyReportError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

/*class GetMonthlyReportInitial extends MonthlyReportState{
  @override
  List<Object?> get props =>[];
}

class GetMonthlyReportLoading extends MonthlyReportState{
  @override
  List<Object?> get props => [];
}
class GetMonthlyReportLoaded extends MonthlyReportState{
  final GetDailyReportModel? data;
  GetMonthlyReportLoaded({this.data});
  @override
  List<Object?> get props => [];
}
class GetMonthlyReportError extends MonthlyReportState{
  final dynamic errors;
  GetMonthlyReportError({this.errors});
  @override
  List<Object?> get props => [errors!];
}*/

