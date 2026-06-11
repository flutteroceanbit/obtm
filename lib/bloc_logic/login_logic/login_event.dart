part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  get email => null;

  get password => null;

  get userType => null;

  get context => null;
}

class FetchLogin extends LoginEvent {
  @override
  final String? email;
  @override
  final String? password;
  @override
  final BuildContext context;
  const FetchLogin({this.password, this.email,required this.context});

  @override
  List<Object?> get props => [];
}