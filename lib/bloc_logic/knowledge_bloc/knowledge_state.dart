import 'package:equatable/equatable.dart';
import 'package:oceanbit_timeclock/models/add_knowledge_model.dart';

import '../../models/get_knowledge_model.dart';
import '../../models/update_knowledge_model.dart';

abstract class KnowledgeState extends Equatable {
  const KnowledgeState();
}

class GetKnowledgeInitial extends KnowledgeState {
  @override
  List<Object?> get props => [];
}

class GetKnowledgeLoading extends KnowledgeState {
  @override
  List<Object?> get props => [];
}

class GetKnowledgeLoaded extends KnowledgeState {
  final GetKnowledgeModel data;
  const GetKnowledgeLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetKnowledgeError extends KnowledgeState {
  final dynamic errors;
  const GetKnowledgeError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class AddKnowledgeLoading extends KnowledgeState {
  @override
  List<Object?> get props => [];
}

class AddKnowledgeLoaded extends KnowledgeState {
  final AddKnowledgeModel data;
  const AddKnowledgeLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class AddKnowledgeError extends KnowledgeState {
  final dynamic errors;
  const AddKnowledgeError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class UpdateKnowledgeLoading extends GetKnowledgeInitial {
  @override
  List<Object?> get props => [];
}

class UpdateKnowledgeLoaded extends GetKnowledgeInitial {
  final UpdateKnowledgeModel? data;
  UpdateKnowledgeLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class UpdateKnowledgeError extends GetKnowledgeInitial {
  final dynamic errors;
  UpdateKnowledgeError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class DeleteKnowledgeLoading extends KnowledgeState {
  @override
  List<Object?> get props => [];
}

class DeleteKnowledgeLoaded extends KnowledgeState {
  final dynamic data;
  const DeleteKnowledgeLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteKnowledgeError extends KnowledgeState {
  final dynamic errors;
  const DeleteKnowledgeError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
