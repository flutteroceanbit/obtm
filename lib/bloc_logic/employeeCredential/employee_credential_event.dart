import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class EmployeeCredentialEvent extends Equatable {
  const EmployeeCredentialEvent();

  get context => null;
  get id => null;
  get userId => null;
  get name => null;
  get email => null;
  get emailPassword => null;
  get skypeName => null;
  get skypePassword => null;
}

class GetEmployeeCredentialEvent extends EmployeeCredentialEvent {
  const GetEmployeeCredentialEvent({required this.context, required this.id});

  @override
  final BuildContext context;
  @override
  final int id;

  @override
  List<Object?> get props => [];
}

class AddEmployeeCredentialEvent extends EmployeeCredentialEvent {
  @override
  final int userId;
  @override
  final String name;
  @override
  final String email;
  @override
  final String emailPassword;
  @override
  final String skypeName;
  @override
  final String skypePassword;
  @override
  final BuildContext context;

  const AddEmployeeCredentialEvent(this.userId, this.name, this.email,
      this.emailPassword, this.skypeName, this.skypePassword,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class UpdateEmployeeCredentialEvent extends EmployeeCredentialEvent {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String name;
  @override
  final String email;
  @override
  final String emailPassword;
  @override
  final String skypeName;
  @override
  final String skypePassword;
  @override
  final BuildContext context;

  const UpdateEmployeeCredentialEvent(this.id, this.userId, this.name,
      this.email, this.emailPassword, this.skypeName, this.skypePassword,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class DeleteEmployeeCredentialEvent extends EmployeeCredentialEvent {
  const DeleteEmployeeCredentialEvent({
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
