import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();
  get context => null;
  get id => null;
  get name => null;
}

class GetDepartmentEvent extends DepartmentEvent {
  const GetDepartmentEvent({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class AddDepartmentEvent extends DepartmentEvent {
  const AddDepartmentEvent({
    required this.context,
    required this.name,
  });

  @override
  final BuildContext context;
  @override
  final String name;

  @override
  List<Object?> get props => [];
}

class UpdateDepartment extends DepartmentEvent {
  const UpdateDepartment(
      {required this.context, required this.name, required this.id});

  @override
  final BuildContext context;
  @override
  final int id;
  @override
  final String name;

  @override
  List<Object?> get props => [];
}

class DeleteDepartment extends DepartmentEvent {
  const DeleteDepartment({
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
