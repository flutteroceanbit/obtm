import 'package:equatable/equatable.dart';

import '../../models/add_employee_credential_model.dart';
import '../../models/get_employee_credential_model.dart';
import '../../models/success_model.dart';
import '../../models/update_employee_creadential.dart';

abstract class EmployeeCredentialState extends Equatable {
  const EmployeeCredentialState();
}

class EmployeeCredentialInitial extends EmployeeCredentialState {
  @override
  List<Object> get props => [];
}

class GetEmployeeCredentialLoading extends EmployeeCredentialState {
  @override
  List<Object> get props => [];
}

class GetEmployeeCredentialLoaded extends EmployeeCredentialState {
  const GetEmployeeCredentialLoaded({this.data});
  final GetEmployeeCredentials? data;
  @override
  List<Object> get props => [data!];
}

class GetEmployeeCredentialError extends EmployeeCredentialState {
  const GetEmployeeCredentialError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class AddEmployeeCredentialLoading extends EmployeeCredentialState {
  @override
  List<Object> get props => [];
}

class AddEmployeeCredentialLoaded extends EmployeeCredentialState {
  const AddEmployeeCredentialLoaded({this.data});
  final AddEmployeeCredentials? data;
  @override
  List<Object> get props => [data!];
}

class AddEmployeeCredentialError extends EmployeeCredentialState {
  const AddEmployeeCredentialError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class UpdateEmployeeCredentialLoading extends EmployeeCredentialState {
  @override
  List<Object> get props => [];
}

class UpdateEmployeeCredentialLoaded extends EmployeeCredentialState {
  const UpdateEmployeeCredentialLoaded({this.data});
  final UpdateEmployeeCredentials? data;
  @override
  List<Object> get props => [data!];
}

class UpdateEmployeeCredentialError extends EmployeeCredentialState {
  const UpdateEmployeeCredentialError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class DeleteEmployeeCredentialLoading extends EmployeeCredentialState {
  @override
  List<Object> get props => [];
}

class DeleteEmployeeCredentialLoaded extends EmployeeCredentialState {
  const DeleteEmployeeCredentialLoaded({this.data});
  final SuccessModel? data;
  @override
  List<Object> get props => [data!];
}

class DeleteEmployeeCredentialError extends EmployeeCredentialState {
  const DeleteEmployeeCredentialError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
