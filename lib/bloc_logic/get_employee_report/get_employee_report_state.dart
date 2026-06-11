import 'package:equatable/equatable.dart';

import '../../models/employee_report_list_model.dart';

abstract class GetEmployeeReportState extends Equatable {
  const GetEmployeeReportState();
}

class GetEmployeeReportInitial extends GetEmployeeReportState {
  @override
  List<Object?> get props => [];
}

class GetEmployeeReportLoading extends GetEmployeeReportState {
  @override
  List<Object?> get props => [];
}

class GetEmployeeReportLoaded extends GetEmployeeReportState {
  final EmployeeReportListModel? data;
  const GetEmployeeReportLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class GetEmployeeReportError extends GetEmployeeReportState {
  final dynamic errors;
  const GetEmployeeReportError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
