import 'package:equatable/equatable.dart';
import '../../models/auth_model.dart';

abstract class UpdateUiState extends Equatable {
  const UpdateUiState();
}

class UpdateUiInitial extends UpdateUiState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class UpdateUiLoading extends UpdateUiState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class UpdateUiLoaded extends UpdateUiState {
  final User? isUpdateUi;
  const UpdateUiLoaded(this.isUpdateUi);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class UpdateUiError extends UpdateUiState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class OpenDialogLoading extends UpdateUiState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class OpenDialogLoaded extends UpdateUiState {
  final bool? isOpenDialog;
  const OpenDialogLoaded(this.isOpenDialog);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class OpenDialogError extends UpdateUiState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class BackLoading extends UpdateUiState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class BackLoaded extends UpdateUiState {
  final bool? isBack;
  const BackLoaded(this.isBack);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class BackError extends UpdateUiState {
  @override
  List<Object?> get props => throw UnimplementedError();
}
