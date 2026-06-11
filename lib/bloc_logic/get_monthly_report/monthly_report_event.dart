part of 'monthly_report_bloc.dart';

abstract class MonthlyReportEvent extends Equatable {
  const MonthlyReportEvent();

  get reportText => null;

  get totalTime => null;

  get context => null;

}

class FetchMonthlyReport extends MonthlyReportEvent{
  @override
  final BuildContext context;
  const FetchMonthlyReport({required this.context});
  @override
  List<Object?> get props => [];
}
