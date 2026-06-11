part of 'local_database_bloc.dart';

abstract class LocalDatabaseEvent extends Equatable {
  const LocalDatabaseEvent();

  get status => null;

  get context => null;

  get timeData => null;

  get sessionTime => null;

  get userId => null;

  get isWorkingTime => null;

  get timer => null;

  get isSync => null;

  get ids => null;
}

class InsertDataEvent extends LocalDatabaseEvent {
  const InsertDataEvent(
      {required this.status,
      required this.context,
      required this.timeData,
      required this.sessionTime,
      required this.isSync});

  @override
  final String status;
  @override
  final BuildContext context;
  @override
  final DateTime timeData;
  @override
  final String sessionTime;
  @override
  final bool isSync;

  @override
  List<Object?> get props => [];
}

class GetSingleDataForTodayByIdEvent extends LocalDatabaseEvent {
  const GetSingleDataForTodayByIdEvent(
      {required this.status, required this.userId});

  @override
  final String status;
  @override
  final String userId;

  @override
  List<Object?> get props => [];
}

class GetSingleDataForInitialEvent extends LocalDatabaseEvent {
  const GetSingleDataForInitialEvent(
      {required this.status, required this.userId});

  @override
  final String status;
  @override
  final String userId;

  @override
  List<Object?> get props => [];
}

class CheckTableEmptyEvent extends LocalDatabaseEvent {
  const CheckTableEmptyEvent();

  @override
  List<Object?> get props => [];
}

class TodayAllDataEvent extends LocalDatabaseEvent {
  const TodayAllDataEvent({required this.userId, required this.isWorkingTime});

  @override
  final String userId;
  @override
  final bool isWorkingTime;

  @override
  List<Object?> get props => [];
}

class CurrentMonthDataEvent extends LocalDatabaseEvent {
  const CurrentMonthDataEvent(
      {required this.userId, required this.isWorkingTime});

  @override
  final String userId;
  @override
  final bool isWorkingTime;

  @override
  List<Object?> get props => [];
}

class GetAllDataEvent extends LocalDatabaseEvent {
  const GetAllDataEvent({required this.userId});

  @override
  final String userId;

  @override
  List<Object?> get props => [];
}

class UpdateIsSyncFlagEvent extends LocalDatabaseEvent {
  const UpdateIsSyncFlagEvent(
      {required this.timer, required this.isSync, required this.context});

  @override
  final TimerDetailData timer;
  @override
  final bool isSync;
  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}
