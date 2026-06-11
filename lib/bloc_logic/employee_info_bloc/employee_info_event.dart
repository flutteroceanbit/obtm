import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class EmployeeInfoEvent extends Equatable {
  const EmployeeInfoEvent();
  get context => null;
  get id => null;
  get userId => null;
  get departmentId => null;
  get designationId => null;
  get period => null;
  get basicSalary => null;
  get startDate => null;
  get hra => null;
  get da => null;
  get ta => null;
  get securityDeposit => null;
  get monthlySecurityDeposit => null;
  get bonusOne => null;
  get bonusTwo => null;
  get minimumFullTime => null;
  get minimumHalfTime => null;
}

class GetEmployeeInfo extends EmployeeInfoEvent {
  const GetEmployeeInfo({required this.context, required this.id});

  @override
  final BuildContext context;
  @override
  final int id;

  @override
  List<Object?> get props => [];
}

class GetEmployeeInfoDetail extends EmployeeInfoEvent {
  const GetEmployeeInfoDetail({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class AddEmployeeInfoEvent extends EmployeeInfoEvent {
  const AddEmployeeInfoEvent({
    required this.context,
    required this.userId,
    required this.departmentId,
    required this.designationId,
    required this.period,
    required this.basicSalary,
    required this.startDate,
    required this.hra,
    required this.da,
    required this.ta,
    required this.securityDeposit,
    required this.monthlySecurityDeposit,
    required this.bonusOne,
    required this.bonusTwo,
    required this.minimumFullTime,
    required this.minimumHalfTime,
  });

  @override
  final BuildContext context;
  @override
  final int userId;
  @override
  final String departmentId;
  @override
  final String designationId;
  @override
  final String period;
  @override
  final String basicSalary;
  @override
  final String startDate;
  @override
  final String hra;
  @override
  final String da;
  @override
  final String ta;
  @override
  final String securityDeposit;
  @override
  final String monthlySecurityDeposit;
  @override
  final String bonusOne;
  @override
  final String bonusTwo;
  @override
  final String minimumFullTime;
  @override
  final String minimumHalfTime;

  @override
  List<Object?> get props => [];
}

class IncrementEvent extends EmployeeInfoEvent {
  const IncrementEvent({
    required this.context,
    required this.userId,
    required this.departmentId,
    required this.designationId,
    required this.basicSalary,
    required this.startDate,
    required this.period,
    required this.hra,
    required this.da,
    required this.ta,
    required this.securityDeposit,
    required this.monthlySecurityDeposit,
    required this.bonusOne,
    required this.bonusTwo,
    required this.minimumFullTime,
    required this.minimumHalfTime,
  });

  @override
  final BuildContext context;
  @override
  final int userId;
  @override
  final String departmentId;
  @override
  final String designationId;
  @override
  final String basicSalary;
  @override
  final String startDate;
  @override
  final String period;
  @override
  final String hra;
  @override
  final String da;
  @override
  final String ta;
  @override
  final String securityDeposit;
  @override
  final String monthlySecurityDeposit;
  @override
  final String bonusOne;
  @override
  final String bonusTwo;
  @override
  final String minimumFullTime;
  @override
  final String minimumHalfTime;

  @override
  List<Object?> get props => [];
}

class UpdateEmployeeInfo extends EmployeeInfoEvent {
  const UpdateEmployeeInfo({
    required this.context,
    required this.userId,
    required this.departmentId,
    required this.designationId,
    required this.period,
    required this.basicSalary,
    required this.startDate,
    required this.hra,
    required this.da,
    required this.ta,
    required this.securityDeposit,
    required this.monthlySecurityDeposit,
    required this.bonusOne,
    required this.bonusTwo,
    required this.minimumFullTime,
    required this.minimumHalfTime,
  });

  @override
  final BuildContext context;
  @override
  final int userId;
  @override
  final String departmentId;
  @override
  final String designationId;
  @override
  final String period;
  @override
  final String basicSalary;
  @override
  final String startDate;
  @override
  final String hra;
  @override
  final String da;
  @override
  final String ta;
  @override
  final String securityDeposit;
  @override
  final String monthlySecurityDeposit;
  @override
  final String bonusOne;
  @override
  final String bonusTwo;
  @override
  final String minimumFullTime;
  @override
  final String minimumHalfTime;

  @override
  List<Object?> get props => [];
}

class DeleteEmployeeInfo extends EmployeeInfoEvent {
  const DeleteEmployeeInfo({
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
