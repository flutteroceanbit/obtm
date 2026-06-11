import 'package:equatable/equatable.dart';
import 'package:oceanbit_timeclock/models/update_leave_model.dart';
import '../../models/add_leave_model.dart';
import '../../models/user_leave_model.dart';
import '../../models/get_leave_by_user.dart';
import '../../models/leave_model.dart';
import '../../models/success_model.dart';

abstract class LeaveState extends Equatable {
  const LeaveState();
}

class LeaveInitial extends LeaveState {
  @override
  List<Object> get props => [];
}

class GetLeaveLoading extends LeaveState {
  @override
  List<Object> get props => [];
}

class GetLeaveLoaded extends LeaveState {
  const GetLeaveLoaded({this.data});
  final LeaveModel? data;
  @override
  List<Object> get props => [data!];
}

class GetLeaveError extends LeaveState {
  const GetLeaveError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class GetLeaveByUserLoading extends LeaveState {
  @override
  List<Object> get props => [];
}

class GetLeaveByUserLoaded extends LeaveState {
  const GetLeaveByUserLoaded({this.data});
  final LeaveByUserModel? data;
  @override
  List<Object> get props => [data!];
}

class GetLeaveByUserError extends LeaveState {
  const GetLeaveByUserError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class GetUserLeaveLoading extends LeaveState {
  @override
  List<Object> get props => [];
}

class GetUserLeaveLoaded extends LeaveState {
  const GetUserLeaveLoaded({this.data});
  final GetUserLeave? data;
  @override
  List<Object> get props => [data!];
}

class GetUserLeaveError extends LeaveState {
  const GetUserLeaveError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class AddLeaveLoading extends LeaveState {
  @override
  List<Object> get props => [];
}

class AddLeaveLoaded extends LeaveState {
  const AddLeaveLoaded({this.data});
  final AddLeaveModel? data;
  @override
  List<Object> get props => [data!];
}

class AddLeaveError extends LeaveState {
  const AddLeaveError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class UpdateLeaveLoading extends LeaveState {
  @override
  List<Object> get props => [];
}

class UpdateLeaveLoaded extends LeaveState {
  const UpdateLeaveLoaded({this.data});
  final UpdateLeaveModel? data;
  @override
  List<Object> get props => [data!];
}

class UpdateLeaveError extends LeaveState {
  const UpdateLeaveError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class DeleteLeaveLoading extends LeaveState {
  @override
  List<Object> get props => [];
}

class DeleteLeaveLoaded extends LeaveState {
  const DeleteLeaveLoaded({this.data});
  final SuccessModel? data;
  @override
  List<Object> get props => [data!];
}

class DeleteLeaveError extends LeaveState {
  const DeleteLeaveError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
