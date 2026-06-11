import 'package:equatable/equatable.dart';
import '../../models/reset_password_model.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();
}

class ResetPasswordInitial extends ResetPasswordState {
  @override
  List<Object> get props => [];
}

class ResetPasswordLoading extends ResetPasswordState {
  @override
  List<Object> get props => [];
}

class ResetPasswordLoaded extends ResetPasswordState {
  const ResetPasswordLoaded({this.data});
  final ResetPasswordModel? data;
  @override
  List<Object> get props => [data!];
}

class ResetPasswordError extends ResetPasswordState {
  const ResetPasswordError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
