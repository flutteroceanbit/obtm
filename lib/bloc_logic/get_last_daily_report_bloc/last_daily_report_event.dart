part of 'last_daily_report_bloc.dart';

abstract class LastDailyReportEvent extends Equatable{
  const LastDailyReportEvent();

  get context => null;
}

class FetchLastDailyReport extends LastDailyReportEvent{
  @override
  final BuildContext context;
  const FetchLastDailyReport({required this.context});
  @override
  List<Object?> get props => [];
}