import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class GetHolidayEvent extends Equatable {
  const GetHolidayEvent();
  get context => null;
  get id => null;
  get startDate => null;
  get endDate => null;
  get desc => null;
  get holidayTypeId => null;
}

class FetchHoliday extends GetHolidayEvent {
  const FetchHoliday({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class FetchHolidayByMonth extends GetHolidayEvent {
  const FetchHolidayByMonth({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class UpdateHoliday extends GetHolidayEvent {
  const UpdateHoliday(
      {required this.context,
      required this.id,
      required this.startDate,
      required this.endDate,
      required this.desc,
      required this.holidayTypeId});

  @override
  final BuildContext context;
  @override
  final String id;
  @override
  final String holidayTypeId;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final String desc;

  @override
  List<Object?> get props => [];
}

class DeleteHoliday extends GetHolidayEvent {
  const DeleteHoliday({
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
