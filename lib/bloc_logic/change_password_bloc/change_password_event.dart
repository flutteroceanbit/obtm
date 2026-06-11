part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  get currentPassword => null;

  get newPassword => null;
  get confirmPassword => null;

  get context => null;
}

class PasswordEvent extends ChangePasswordEvent {
  @override
  final String currentPassword;
  @override
  final String newPassword;
  @override
  final String confirmPassword;
  @override
  final BuildContext context;
  const PasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.context,
  });

  @override
  List<Object?> get props => [];
}
