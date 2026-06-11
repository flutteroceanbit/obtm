import 'package:equatable/equatable.dart';
import 'package:oceanbit_timeclock/models/holiday_type_model.dart';

import '../../models/update_holiday_type_model.dart';

abstract class GetHolidayTypeState extends Equatable {
  const GetHolidayTypeState();
}

class GetHolidayTypeInitial extends GetHolidayTypeState {
  @override
  List<Object?> get props => [];
}

class GetHolidayTypeLoading extends GetHolidayTypeState {
  @override
  List<Object?> get props => [];
}

class GetHolidayTypeLoaded extends GetHolidayTypeState {
  final HolidayTypeModel? data;
  const GetHolidayTypeLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class GetHolidayTypeError extends GetHolidayTypeState {
  final dynamic errors;
  const GetHolidayTypeError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class UpdateHolidayTypeLoading extends GetHolidayTypeState {
  @override
  List<Object?> get props => [];
}

class UpdateHolidayTypeLoaded extends GetHolidayTypeState {
  final UpdateHolidayType? data;
  const UpdateHolidayTypeLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class UpdateHolidayTypeError extends GetHolidayTypeState {
  final dynamic errors;
  const UpdateHolidayTypeError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class DeleteHolidayTypeLoading extends GetHolidayTypeState {
  @override
  List<Object?> get props => [];
}

class DeleteHolidayTypeLoaded extends GetHolidayTypeState {
  final dynamic data;
  const DeleteHolidayTypeLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteHolidayTypeError extends GetHolidayTypeState {
  final dynamic errors;
  const DeleteHolidayTypeError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
