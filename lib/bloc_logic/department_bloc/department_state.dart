import 'package:equatable/equatable.dart';
import 'package:oceanbit_timeclock/models/add_Department_model.dart';

import '../../models/get_department_model.dart';
import '../../models/update_Department_model.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();
}

class DepartmentInitial extends DepartmentState {
  @override
  List<Object?> get props => [];
}

class GetDepartmentLoading extends DepartmentState {
  @override
  List<Object?> get props => [];
}

class GetDepartmentLoaded extends DepartmentState {
  final GetDepartmentModel data;
  const GetDepartmentLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetDepartmentError extends DepartmentState {
  final dynamic errors;
  const GetDepartmentError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class AddDepartmentLoading extends DepartmentState {
  @override
  List<Object?> get props => [];
}

class AddDepartmentLoaded extends DepartmentState {
  final AddDepartmentModel data;
  const AddDepartmentLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class AddDepartmentError extends DepartmentState {
  final dynamic errors;
  const AddDepartmentError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class UpdateDepartmentLoading extends DepartmentState {
  @override
  List<Object?> get props => [];
}

class UpdateDepartmentLoaded extends DepartmentState {
  final UpdateDepartmentModel? data;
  const UpdateDepartmentLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class UpdateDepartmentError extends DepartmentState {
  final dynamic errors;
  const UpdateDepartmentError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class DeleteDepartmentLoading extends DepartmentState {
  @override
  List<Object?> get props => [];
}

class DeleteDepartmentLoaded extends DepartmentState {
  final dynamic data;
  const DeleteDepartmentLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteDepartmentError extends DepartmentState {
  final dynamic errors;
  const DeleteDepartmentError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
