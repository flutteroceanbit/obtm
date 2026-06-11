import 'package:equatable/equatable.dart';

import '../../models/rules/add_rules_model.dart';
import '../../models/rules/get_rules_model.dart';
import '../../models/rules/update_rules_model.dart';

abstract class RulesState extends Equatable {
  const RulesState();
}

class RulesInitial extends RulesState {
  @override
  List<Object?> get props => [];
}

class GetRulesLoading extends RulesState {
  @override
  List<Object?> get props => [];
}

class GetRulesLoaded extends RulesState {
  final GetRulesModel data;
  const GetRulesLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetRulesError extends RulesState {
  final dynamic errors;
  const GetRulesError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class AddRulesLoading extends RulesState {
  @override
  List<Object?> get props => [];
}

class AddRulesLoaded extends RulesState {
  final AddRulesModel data;
  const AddRulesLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class AddRulesError extends RulesState {
  final dynamic errors;
  const AddRulesError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class UpdateRulesLoading extends RulesInitial {
  @override
  List<Object?> get props => [];
}

class UpdateRulesLoaded extends RulesInitial {
  final UpdateRulesModel? data;
  UpdateRulesLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class UpdateRulesError extends RulesInitial {
  final dynamic errors;
  UpdateRulesError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class DeleteRulesLoading extends RulesState {
  @override
  List<Object?> get props => [];
}

class DeleteRulesLoaded extends RulesState {
  final dynamic data;
  const DeleteRulesLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteRulesError extends RulesState {
  final dynamic errors;
  const DeleteRulesError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
