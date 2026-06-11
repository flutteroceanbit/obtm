import 'package:equatable/equatable.dart';
import '../../models/add_previous_employer.dart';
import '../../models/get_previous_employer_model.dart';
import '../../models/success_model.dart';
import '../../models/update_previous_emaployer.dart';

abstract class PreviousEmployerState extends Equatable {
  const PreviousEmployerState();
}

class PreviousEmployerInitial extends PreviousEmployerState {
  @override
  List<Object> get props => [];
}

class GetPreviousEmployerLoading extends PreviousEmployerState {
  @override
  List<Object> get props => [];
}

class GetPreviousEmployerLoaded extends PreviousEmployerState {
  const GetPreviousEmployerLoaded({this.data});
  final GetPreviousEmployerModel? data;
  @override
  List<Object> get props => [data!];
}

class GetPreviousEmployerError extends PreviousEmployerState {
  const GetPreviousEmployerError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class AddPreviousEmployerLoading extends PreviousEmployerState {
  @override
  List<Object> get props => [];
}

class AddPreviousEmployerLoaded extends PreviousEmployerState {
  const AddPreviousEmployerLoaded({this.data});
  final AddPreviousEmployerModel? data;
  @override
  List<Object> get props => [data!];
}

class AddPreviousEmployerError extends PreviousEmployerState {
  const AddPreviousEmployerError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class UpdatePreviousEmployerLoading extends PreviousEmployerState {
  @override
  List<Object> get props => [];
}

class UpdatePreviousEmployerLoaded extends PreviousEmployerState {
  const UpdatePreviousEmployerLoaded({this.data});
  final UpdatePreviousEmployerModel? data;
  @override
  List<Object> get props => [data!];
}

class UpdatePreviousEmployerError extends PreviousEmployerState {
  const UpdatePreviousEmployerError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class DeletePreviousEmployerLoading extends PreviousEmployerState {
  @override
  List<Object> get props => [];
}

class DeletePreviousEmployerLoaded extends PreviousEmployerState {
  const DeletePreviousEmployerLoaded({this.data});
  final SuccessModel? data;
  @override
  List<Object> get props => [data!];
}

class DeletePreviousEmployerError extends PreviousEmployerState {
  const DeletePreviousEmployerError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
