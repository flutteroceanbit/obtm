import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SystemFaultEvent extends Equatable {
  const SystemFaultEvent();

  get context => null;
  get id => null;
  get systemType => null;
  get description => null;
  get status => null;
}

class GetSystemFaultEvent extends SystemFaultEvent {
  const GetSystemFaultEvent({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class GetAdminSystemFaultEvent extends SystemFaultEvent {
  const GetAdminSystemFaultEvent({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class AddSystemFaultEvent extends SystemFaultEvent {
  @override
  final String systemType;

  @override
  final String description;
  @override
  final BuildContext context;

  const AddSystemFaultEvent(this.systemType, this.description,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class UpdateSystemFaultEvent extends SystemFaultEvent {
  @override
  final int id;
  @override
  final String systemType;
  @override
  final String description;
  @override
  final BuildContext context;

  const UpdateSystemFaultEvent(this.id, this.systemType, this.description,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class UpdateAdminSystemFaultEvent extends SystemFaultEvent {
  @override
  final int id;
  @override
  final String status;
  @override
  final BuildContext context;

  const UpdateAdminSystemFaultEvent(this.id, this.status,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class DeleteSystemFaultEvent extends SystemFaultEvent {
  const DeleteSystemFaultEvent({
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
