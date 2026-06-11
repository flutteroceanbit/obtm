part of 'get_daily_report_bloc.dart';

abstract class GetDailyReportEvent extends Equatable {
  const GetDailyReportEvent();

  get reportText => null;

  get totalTime => null;

  get context => null;

}

class FetchGetDailyReport extends GetDailyReportEvent{
  @override
  final BuildContext context;
  const FetchGetDailyReport({required this.context});
  @override
  List<Object?> get props => [];

}

class FetchGetMonthlyReport extends GetDailyReportEvent{
  @override
  final BuildContext context;
  const FetchGetMonthlyReport({required this.context});
  @override
  List<Object?> get props => [];
}


