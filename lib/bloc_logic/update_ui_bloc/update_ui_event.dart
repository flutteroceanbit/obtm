import 'package:equatable/equatable.dart';

import '../../models/auth_model.dart';

abstract class UpdateUiEvent extends Equatable {
  get isUpdateUi => null;
  get isOpenDialog => null;
  const UpdateUiEvent();
}

class AddUpdateUi extends UpdateUiEvent {
  @override
  final User isUpdateUi;

  const AddUpdateUi(this.isUpdateUi);
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddOpenDialog extends UpdateUiEvent {
  @override
  final bool isOpenDialog;

  const AddOpenDialog(this.isOpenDialog);
  @override
  List<Object?> get props => throw UnimplementedError();
}

class BackSetting extends UpdateUiEvent {
  @override
  final bool isBack;

  const BackSetting(this.isBack);
  @override
  List<Object?> get props => throw UnimplementedError();
}
