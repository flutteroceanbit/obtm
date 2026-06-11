part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordLoading extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordLoaded extends ChangePasswordState {
  const ChangePasswordLoaded({required this.data});
  final bool data;
  @override
  List<Object> get props => [data];
}

class ChangePasswordError extends ChangePasswordState {
  const ChangePasswordError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
