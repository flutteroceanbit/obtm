import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class GetHolidayTypeEvent extends Equatable {
  const GetHolidayTypeEvent();
  get context => null;
  get id => null;
  get name => null;
  get isMulti => null;
}

class FetchHolidayType extends GetHolidayTypeEvent {
  const FetchHolidayType({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class UpdateHolidayType extends GetHolidayTypeEvent {
  const UpdateHolidayType(
      {required this.context,
      required this.id,
      required this.name,
      required this.isMulti});

  @override
  final BuildContext context;
  @override
  final String id;
  @override
  final String name;
  @override
  final bool isMulti;

  @override
  List<Object?> get props => [];
}

class DeleteHolidayType extends GetHolidayTypeEvent {
  const DeleteHolidayType({
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
