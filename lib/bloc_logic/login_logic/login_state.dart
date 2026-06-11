part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoaded extends LoginState {
  const LoginLoaded({this.data});
  final AuthModel? data;
  @override
  List<Object> get props => [data!];
}

class LoginError extends LoginState {
  const LoginError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
