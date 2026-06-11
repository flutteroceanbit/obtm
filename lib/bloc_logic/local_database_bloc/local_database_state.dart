part of 'local_database_bloc.dart';

abstract class LocalDatabaseState extends Equatable {
  const LocalDatabaseState();
}

class LocalDatabaseInitial extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class InsertDataLoading extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class InsertDataLoaded extends LocalDatabaseState {
  const InsertDataLoaded({this.data, this.timeStatus});
  final int? data;
  final String? timeStatus;
  @override
  List<Object> get props => [data!];
}

class InsertDataError extends LocalDatabaseState {
  const InsertDataError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class GetSingleDataForTodayByIdLoading extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class GetSingleDataForTodayByIdLoaded extends LocalDatabaseState {
  const GetSingleDataForTodayByIdLoaded({this.data, this.timeStatus});
  final TimerDetailData? data;
  final String? timeStatus;
  @override
  List<Object> get props => [data!, timeStatus!];
}

class GetSingleDataForTodayByIdError extends LocalDatabaseState {
  const GetSingleDataForTodayByIdError({this.errors, this.status});
  final dynamic errors;
  final String? status;
  @override
  List<Object> get props => [errors!];
}

class GetSingleDataForInitialLoading extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class GetSingleDataForInitialLoaded extends LocalDatabaseState {
  const GetSingleDataForInitialLoaded({this.data, this.timeStatus});
  final TimerDetailData? data;
  final String? timeStatus;
  @override
  List<Object> get props => [data!, timeStatus!];
}

class GetSingleDataForInitialError extends LocalDatabaseState {
  const GetSingleDataForInitialError({this.errors, this.status});
  final dynamic errors;
  final String? status;
  @override
  List<Object> get props => [errors!];
}

class TodayAllDataLoading extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class TodayAllDataLoaded extends LocalDatabaseState {
  const TodayAllDataLoaded({this.data, required this.isWorkingTime});
  final List<TimerDetailData>? data;
  final bool isWorkingTime;
  @override
  List<Object> get props => [data!, isWorkingTime];
}

class TodayAllDataError extends LocalDatabaseState {
  const TodayAllDataError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class CurrentMonthDataLoading extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class CurrentMonthDataLoaded extends LocalDatabaseState {
  const CurrentMonthDataLoaded({this.data, required this.isWorkingTime});
  final List<TimerDetailData>? data;
  final bool isWorkingTime;
  @override
  List<Object> get props => [data!, isWorkingTime];
}

class CurrentMonthDataError extends LocalDatabaseState {
  const CurrentMonthDataError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class CheckTableEmptyLoading extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class CheckTableEmptyLoaded extends LocalDatabaseState {
  const CheckTableEmptyLoaded({required this.count});
  final Expression<int> count;
  @override
  List<Object> get props => [count];
}

class CheckTableEmptyError extends LocalDatabaseState {
  const CheckTableEmptyError({this.errors});
  final dynamic errors;

  @override
  List<Object> get props => [errors!];
}

class AllDataLoading extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class AllDataLoaded extends LocalDatabaseState {
  const AllDataLoaded({required this.data});
  final List<TimerDetailData>? data;
  @override
  List<Object> get props => [data!];
}

class AllDataError extends LocalDatabaseState {
  const AllDataError({this.errors});
  final dynamic errors;

  @override
  List<Object> get props => [errors!];
}

///update isSync flag
class UpdateIsSyncFlagLoading extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class UpdateIsSyncFlagLoaded extends LocalDatabaseState {
  const UpdateIsSyncFlagLoaded({required this.isSync});

  final bool isSync;
  @override
  List<Object> get props => [];
}

class UpdateIsSyncFlagError extends LocalDatabaseState {
  const UpdateIsSyncFlagError({this.errors});
  final dynamic errors;

  @override
  List<Object> get props => [errors!];
}

///update isSync by Id flag
class UpdateIsSyncByIdLoading extends LocalDatabaseState {
  @override
  List<Object> get props => [];
}

class UpdateIsSyncByIdLoaded extends LocalDatabaseState {
  const UpdateIsSyncByIdLoaded({required this.isSync});

  final bool isSync;
  @override
  List<Object> get props => [];
}

class UpdateIsSyncByIdError extends LocalDatabaseState {
  const UpdateIsSyncByIdError({this.errors});
  final dynamic errors;

  @override
  List<Object> get props => [errors!];
}
