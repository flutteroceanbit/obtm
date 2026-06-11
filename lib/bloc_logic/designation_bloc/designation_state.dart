import 'package:equatable/equatable.dart';

import '../../models/add_designation_model.dart';
import '../../models/get_designation_model.dart';
import '../../models/update_designation_model.dart';

abstract class DesignationState extends Equatable {
  const DesignationState();
}

class DesignationInitial extends DesignationState {
  @override
  List<Object?> get props => [];
}

class GetDesignationLoading extends DesignationState {
  @override
  List<Object?> get props => [];
}

class GetDesignationLoaded extends DesignationState {
  final GetDesignationModel data;
  const GetDesignationLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetDesignationError extends DesignationState {
  final dynamic errors;
  const GetDesignationError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class AddDesignationLoading extends DesignationState {
  @override
  List<Object?> get props => [];
}

class AddDesignationLoaded extends DesignationState {
  final AddDesignationModel data;
  const AddDesignationLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class AddDesignationError extends DesignationState {
  final dynamic errors;
  const AddDesignationError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class UpdateDesignationLoading extends DesignationState {
  @override
  List<Object?> get props => [];
}

class UpdateDesignationLoaded extends DesignationState {
  final UpdateDesignationModel? data;
  const UpdateDesignationLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class UpdateDesignationError extends DesignationState {
  final dynamic errors;
  const UpdateDesignationError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class DeleteDesignationLoading extends DesignationState {
  @override
  List<Object?> get props => [];
}

class DeleteDesignationLoaded extends DesignationState {
  final dynamic data;
  const DeleteDesignationLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteDesignationError extends DesignationState {
  final dynamic errors;
  const DeleteDesignationError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
