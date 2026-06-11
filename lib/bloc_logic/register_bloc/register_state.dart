import 'package:equatable/equatable.dart';

import '../../models/auth_model.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitialState extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterLoadingState extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterLoadedState extends RegisterState {
  final AuthModel? data;
  const RegisterLoadedState({this.data});
  @override
  List<Object?> get props => [];
}

class RegisterErrorState extends RegisterState {
  final dynamic error;
  const RegisterErrorState({this.error});
  @override
  List<Object?> get props => [];
}
