import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RulesEvent extends Equatable {
  const RulesEvent();
  get context => null;
  get id => null;
  get rule => null;
}

class GetRules extends RulesEvent {
  const GetRules({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class AddRulesEvent extends RulesEvent {
  const AddRulesEvent({
    required this.context,
    required this.rule,
  });

  @override
  final BuildContext context;
  @override
  final String rule;

  @override
  List<Object?> get props => [];
}

class UpdateRules extends RulesEvent {
  const UpdateRules(
      {required this.context, required this.rule, required this.id});

  @override
  final BuildContext context;
  @override
  final int id;
  @override
  final String rule;

  @override
  List<Object?> get props => [];
}

class DeleteRules extends RulesEvent {
  const DeleteRules({
    required this.context,
    required this.id,
  });

  @override
  final BuildContext context;
  @override
  final int id;

  @override
  List<Object?> get props => [];
}
