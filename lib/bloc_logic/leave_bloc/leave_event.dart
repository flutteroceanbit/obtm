import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  get context => null;
  get id => null;
  get userId => null;
  get startDate => null;
  get endDate => null;
  get reason => null;
  get leaveTypeValue => null;
  get leaveValue => null;
  get leaveStatusValue => null;
  get leaveId => null;
  get status => null;
  get text => null;
}

class GetLeaveEvent extends LeaveEvent {
  GetLeaveEvent(
      {required this.context,
      this.text,
      this.startDate,
      this.endDate,
      this.status});

  @override
  final BuildContext context;
  @override
  String? text;
  @override
  String? startDate;
  @override
  String? endDate;
  @override
  String? status;

  @override
  List<Object?> get props => [];
}

class GetLeaveByUserEvent extends LeaveEvent {
  const GetLeaveByUserEvent({required this.context, required this.userId});

  @override
  final BuildContext context;
  @override
  final int userId;

  @override
  List<Object?> get props => [];
}

class GetUserLeaveEvent extends LeaveEvent {
  const GetUserLeaveEvent({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class AddLeaveEvent extends LeaveEvent {
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final String reason;
  @override
  final String leaveTypeValue;
  @override
  final String leaveValue;
  @override
  final BuildContext context;

  const AddLeaveEvent(this.startDate, this.endDate, this.reason,
      this.leaveTypeValue, this.leaveValue,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class UpdateLeaveEvent extends LeaveEvent {
  @override
  final int userId;
  @override
  final int leaveId;
  @override
  final int leaveStatusValue;
  @override
  final BuildContext context;

  const UpdateLeaveEvent(this.userId, this.leaveId, this.leaveStatusValue,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class DeleteLeaveEvent extends LeaveEvent {
  const DeleteLeaveEvent({
    required this.context,
    required this.id,
  });

  @override
  final BuildContext context;
  @override
  final String id;

  @override
  List<Object?> get props => [];
}
