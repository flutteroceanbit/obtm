part of 'add_daily_report_bloc.dart';

abstract class AddDailyReportEvent extends Equatable {
  const AddDailyReportEvent();

  get reportText => null;

  get totalTime => null;
  get intermediateTime => null;

  get context => null;
}

class AddReportEvent extends AddDailyReportEvent {
  @override
  final String? reportText;
  @override
  final String? totalTime;
  @override
  final String? intermediateTime;
  @override
  final BuildContext context;
  const AddReportEvent(
      {this.reportText,
      this.totalTime,
      required this.context,
      required this.intermediateTime});

  @override
  List<Object?> get props => [];
}
