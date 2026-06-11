import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AddHolidayEvent extends Equatable {
  const AddHolidayEvent();

  get holidayTypeId => null;

  get startDate => null;
  get description => null;
  get endDate => null;

  get context => null;
}

class AddHolidayWithType extends AddHolidayEvent {
  @override
  final int holidayTypeId;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final String description;
  @override
  final BuildContext context;
  const AddHolidayWithType(
      {required this.holidayTypeId,
      required this.startDate,
      required this.endDate,
      required this.description,
      required this.context});

  @override
  List<Object?> get props => [];
}
