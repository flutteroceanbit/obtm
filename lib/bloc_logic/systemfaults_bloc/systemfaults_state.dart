import 'package:equatable/equatable.dart';
import '../../models/add_system_fault_model.dart';
import '../../models/get_admin_system_fault_model.dart';
import '../../models/get_system_fault_model.dart';
import '../../models/update_admin_system_fault_model.dart';
import '../../models/update_system_fault_model.dart';
import '../../models/success_model.dart';

abstract class SystemFaultState extends Equatable {
  const SystemFaultState();
}

class SystemFaultInitial extends SystemFaultState {
  @override
  List<Object> get props => [];
}

class GetSystemFaultLoading extends SystemFaultState {
  @override
  List<Object> get props => [];
}

class GetSystemFaultLoaded extends SystemFaultState {
  const GetSystemFaultLoaded({this.data});
  final GetSystemFaultModel? data;
  @override
  List<Object> get props => [data!];
}

class GetSystemFaultError extends SystemFaultState {
  const GetSystemFaultError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class GetAdminSystemFaultLoading extends SystemFaultState {
  @override
  List<Object> get props => [];
}

class GetAdminSystemFaultLoaded extends SystemFaultState {
  const GetAdminSystemFaultLoaded({this.data});
  final GetAdminSystemFaultModel? data;
  @override
  List<Object> get props => [data!];
}

class GetAdminSystemFaultError extends SystemFaultState {
  const GetAdminSystemFaultError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class AddSystemFaultLoading extends SystemFaultState {
  @override
  List<Object> get props => [];
}

class AddSystemFaultLoaded extends SystemFaultState {
  const AddSystemFaultLoaded({this.data});
  final AddSystemFaultModel? data;
  @override
  List<Object> get props => [data!];
}

class AddSystemFaultError extends SystemFaultState {
  const AddSystemFaultError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class UpdateSystemFaultLoading extends SystemFaultState {
  @override
  List<Object> get props => [];
}

class UpdateSystemFaultLoaded extends SystemFaultState {
  const UpdateSystemFaultLoaded({this.data});
  final UpdateSystemFaultModel? data;
  @override
  List<Object> get props => [data!];
}

class UpdateSystemFaultError extends SystemFaultState {
  const UpdateSystemFaultError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class UpdateAdminSystemFaultLoading extends SystemFaultState {
  @override
  List<Object> get props => [];
}

class UpdateAdminSystemFaultLoaded extends SystemFaultState {
  const UpdateAdminSystemFaultLoaded({this.data});
  final UpdateAdminSystemFaultModel? data;
  @override
  List<Object> get props => [data!];
}

class UpdateAdminSystemFaultError extends SystemFaultState {
  const UpdateAdminSystemFaultError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class DeleteSystemFaultLoading extends SystemFaultState {
  @override
  List<Object> get props => [];
}

class DeleteSystemFaultLoaded extends SystemFaultState {
  const DeleteSystemFaultLoaded({this.data});
  final SuccessModel? data;
  @override
  List<Object> get props => [data!];
}

class DeleteSystemFaultError extends SystemFaultState {
  const DeleteSystemFaultError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
