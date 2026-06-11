import 'package:equatable/equatable.dart';
import '../../models/get_holiday_by_month.dart';
import '../../models/holiday_model.dart';
import '../../models/update_holiday_model.dart';

abstract class GetHolidayState extends Equatable {
  const GetHolidayState();
}

class GetHolidayInitial extends GetHolidayState {
  @override
  List<Object?> get props => [];
}

class GetHolidayLoading extends GetHolidayState {
  @override
  List<Object?> get props => [];
}

class GetHolidayLoaded extends GetHolidayState {
  final HolidayModel data;
  const GetHolidayLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetHolidayError extends GetHolidayState {
  final dynamic errors;
  const GetHolidayError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class GetHolidayByMonthLoading extends GetHolidayState {
  @override
  List<Object?> get props => [];
}

class GetHolidayByMonthLoaded extends GetHolidayState {
  final GetHolidayByMonth data;
  const GetHolidayByMonthLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetHolidayByMonthError extends GetHolidayState {
  final dynamic errors;
  const GetHolidayByMonthError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class UpdateHolidayLoading extends GetHolidayInitial {
  @override
  List<Object?> get props => [];
}

class UpdateHolidayLoaded extends GetHolidayInitial {
  final UpdateHolidayModel? data;
  UpdateHolidayLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class UpdateHolidayError extends GetHolidayInitial {
  final dynamic errors;
  UpdateHolidayError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class DeleteHolidayLoading extends GetHolidayState {
  @override
  List<Object?> get props => [];
}

class DeleteHolidayLoaded extends GetHolidayState {
  final dynamic data;
  const DeleteHolidayLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteHolidayError extends GetHolidayState {
  final dynamic errors;
  const DeleteHolidayError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
