import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DesignationEvent extends Equatable {
  const DesignationEvent();
  get context => null;
  get id => null;
  get name => null;
  get shortName => null;
}

class GetDesignation extends DesignationEvent {
  const GetDesignation({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class AddDesignationEvent extends DesignationEvent {
  const AddDesignationEvent({
    required this.context,
    required this.name,
    required this.shortName,
  });

  @override
  final BuildContext context;
  @override
  final String name;
  @override
  final String shortName;

  @override
  List<Object?> get props => [];
}

class UpdateDesignation extends DesignationEvent {
  const UpdateDesignation({
    required this.context,
    required this.id,
    required this.name,
    required this.shortName,
  });

  @override
  final BuildContext context;
  @override
  final int id;
  @override
  final String name;
  @override
  final String shortName;

  @override
  List<Object?> get props => [];
}

class DeleteDesignation extends DesignationEvent {
  const DeleteDesignation({
    required this.context,
    required this.id,
  });

  @override
  final BuildContext context;
  @override
  final String id;

  @override
  List<Object?> get props => [];
}
