import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  get firstName => null;

  get lastName => null;

  get email => null;

  get phone => null;

  get password => null;

  get confirmPassword => null;

  get context => null;
}

class FetchRegisterEvent extends RegisterEvent {
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? password;
  @override
  final String? confirmPassword;
  @override
  final BuildContext context;
  const FetchRegisterEvent(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.password,
      this.confirmPassword,
      required this.context});
  @override
  List<Object?> get props => [];
}
