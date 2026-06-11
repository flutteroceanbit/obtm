import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class GetEmployeeReportEvent extends Equatable {
  const GetEmployeeReportEvent();
  get id => null;
  get year => null;
  get context => null;
}

class FetchEmployeeReport extends GetEmployeeReportEvent {
  const FetchEmployeeReport(this.year,
      {required this.id, required this.context});
  @override
  final int id;
  @override
  final int year;
  @override
  final BuildContext context;
  @override
  List<Object?> get props => [id];
}
