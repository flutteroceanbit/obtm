import 'package:equatable/equatable.dart';
import '../../models/add_holiday_model.dart';

abstract class AddHolidayState extends Equatable {
  const AddHolidayState();
}

class AddHolidayInitial extends AddHolidayState {
  @override
  List<Object> get props => [];
}

class AddHolidayLoading extends AddHolidayState {
  @override
  List<Object> get props => [];
}

class AddHolidayLoaded extends AddHolidayState {
  const AddHolidayLoaded({this.data});
  final AddHolidayModel? data;
  @override
  List<Object> get props => [data!];
}

class AddHolidayError extends AddHolidayState {
  const AddHolidayError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
