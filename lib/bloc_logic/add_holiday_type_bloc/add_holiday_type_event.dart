import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AddHolidayTypeEvent extends Equatable {
  const AddHolidayTypeEvent();

  get name => null;

  get isMulti => null;

  get context => null;
}

class AddHolidayTypeForEvent extends AddHolidayTypeEvent {
  @override
  final String name;
  @override
  final bool isMulti;
  @override
  final BuildContext context;
  const AddHolidayTypeForEvent(
      {required this.name, required this.isMulti, required this.context});

  @override
  List<Object?> get props => [];
}
