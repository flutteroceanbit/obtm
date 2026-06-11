import 'package:equatable/equatable.dart';

import '../../models/add_employee_info_model.dart';
import '../../models/employee_ifo_detail_model.dart';
import '../../models/get_employee_info_model.dart';
import '../../models/increment_model.dart';
import '../../models/update_employee_info_model.dart';

abstract class EmployeeInfoState extends Equatable {
  const EmployeeInfoState();
}

class EmployeeInfoInitial extends EmployeeInfoState {
  @override
  List<Object?> get props => [];
}

class GetEmployeeInfoLoading extends EmployeeInfoState {
  @override
  List<Object?> get props => [];
}

class GetEmployeeInfoLoaded extends EmployeeInfoState {
  final GetEmployeeInfoModel data;
  const GetEmployeeInfoLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetEmployeeInfoError extends EmployeeInfoState {
  final dynamic errors;
  const GetEmployeeInfoError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class IncrementLoading extends EmployeeInfoState {
  @override
  List<Object?> get props => [];
}

class IncrementLoaded extends EmployeeInfoState {
  final IncrementModel data;
  const IncrementLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class IncrementError extends EmployeeInfoState {
  final dynamic errors;
  const IncrementError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class GetEmployeeInfoDetailLoading extends EmployeeInfoState {
  @override
  List<Object?> get props => [];
}

class GetEmployeeInfoDetailLoaded extends EmployeeInfoState {
  final GetEmployeeInfoDetailModel data;
  const GetEmployeeInfoDetailLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetEmployeeInfoDetailError extends EmployeeInfoState {
  final dynamic errors;
  const GetEmployeeInfoDetailError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class AddEmployeeInfoLoading extends EmployeeInfoState {
  @override
  List<Object?> get props => [];
}

class AddEmployeeInfoLoaded extends EmployeeInfoState {
  final AddEmployeeInfoModel data;
  const AddEmployeeInfoLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class AddEmployeeInfoError extends EmployeeInfoState {
  final dynamic errors;
  const AddEmployeeInfoError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class UpdateEmployeeInfoLoading extends EmployeeInfoInitial {
  @override
  List<Object?> get props => [];
}

class UpdateEmployeeInfoLoaded extends EmployeeInfoInitial {
  final UpdateEmployeeInfoModel? data;
  UpdateEmployeeInfoLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class UpdateEmployeeInfoError extends EmployeeInfoInitial {
  final dynamic errors;
  UpdateEmployeeInfoError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class DeleteEmployeeInfoLoading extends EmployeeInfoState {
  @override
  List<Object?> get props => [];
}

class DeleteEmployeeInfoLoaded extends EmployeeInfoState {
  final dynamic data;
  const DeleteEmployeeInfoLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteEmployeeInfoError extends EmployeeInfoState {
  final dynamic errors;
  const DeleteEmployeeInfoError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
