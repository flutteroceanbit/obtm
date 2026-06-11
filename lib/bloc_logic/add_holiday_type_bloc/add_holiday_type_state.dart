import 'package:equatable/equatable.dart';
import 'package:oceanbit_timeclock/models/add_holiday_type_model.dart';

abstract class AddHolidayTypeState extends Equatable {
  const AddHolidayTypeState();
}

class AddHolidayTypeInitial extends AddHolidayTypeState {
  @override
  List<Object> get props => [];
}

class AddHolidayTypeLoading extends AddHolidayTypeState {
  @override
  List<Object> get props => [];
}

class AddHolidayTypeLoaded extends AddHolidayTypeState {
  const AddHolidayTypeLoaded({this.data});
  final AddHolidayTypeModel? data;
  @override
  List<Object> get props => [data!];
}

class AddHolidayTypeError extends AddHolidayTypeState {
  const AddHolidayTypeError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
