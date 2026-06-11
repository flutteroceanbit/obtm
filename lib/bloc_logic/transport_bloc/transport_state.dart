import 'package:equatable/equatable.dart';
import 'package:oceanbit_timeclock/models/add_transport_model.dart';
import 'package:oceanbit_timeclock/models/get_transport_model.dart';
import '../../models/success_model.dart';

abstract class TransportState extends Equatable {
  const TransportState();
}

class TransportInitial extends TransportState {
  @override
  List<Object> get props => [];
}

class GetTransportLoading extends TransportState {
  @override
  List<Object> get props => [];
}

class GetTransportLoaded extends TransportState {
  const GetTransportLoaded({this.data});
  final GetTransportModel? data;
  @override
  List<Object> get props => [data!];
}

class GetTransportError extends TransportState {
  const GetTransportError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class AddTransportLoading extends TransportState {
  @override
  List<Object> get props => [];
}

class AddTransportLoaded extends TransportState {
  const AddTransportLoaded({this.data});
  final AddTransportModel? data;
  @override
  List<Object> get props => [data!];
}

class AddTransportError extends TransportState {
  const AddTransportError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class DeleteTransportLoading extends TransportState {
  @override
  List<Object> get props => [];
}

class DeleteTransportLoaded extends TransportState {
  const DeleteTransportLoaded({this.data});
  final SuccessModel? data;
  @override
  List<Object> get props => [data!];
}

class DeleteTransportError extends TransportState {
  const DeleteTransportError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
