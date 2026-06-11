import 'package:equatable/equatable.dart';
import 'package:oceanbit_timeclock/models/add_inventory_model.dart';
import '../../models/get_inventory_by_id_model.dart';
import '../../models/get_inventory_model.dart';
import '../../models/update_inventory_model.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();
}

class InventoryInitial extends InventoryState {
  @override
  List<Object?> get props => [];
}

class GetInventoryLoading extends InventoryState {
  @override
  List<Object?> get props => [];
}

class GetInventoryLoaded extends InventoryState {
  final GetInventoryModel data;
  const GetInventoryLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetInventoryError extends InventoryState {
  final dynamic errors;
  const GetInventoryError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class GetInventoryByIdLoading extends InventoryState {
  @override
  List<Object?> get props => [];
}

class GetInventoryByIdLoaded extends InventoryState {
  final GetInventoryByIdModel data;
  const GetInventoryByIdLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetInventoryByIdError extends InventoryState {
  final dynamic errors;
  const GetInventoryByIdError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class AddInventoryLoading extends InventoryState {
  @override
  List<Object?> get props => [];
}

class AddInventoryLoaded extends InventoryState {
  final AddInventoryModel data;
  const AddInventoryLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class AddInventoryError extends InventoryState {
  final dynamic errors;
  const AddInventoryError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class UpdateInventoryLoading extends InventoryInitial {
  @override
  List<Object?> get props => [];
}

class UpdateInventoryLoaded extends InventoryInitial {
  final UpdateInventoryModel? data;
  UpdateInventoryLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class UpdateInventoryError extends InventoryInitial {
  final dynamic errors;
  UpdateInventoryError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class DeleteInventoryLoading extends InventoryState {
  @override
  List<Object?> get props => [];
}

class DeleteInventoryLoaded extends InventoryState {
  final dynamic data;
  const DeleteInventoryLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteInventoryError extends InventoryState {
  final dynamic errors;
  const DeleteInventoryError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
