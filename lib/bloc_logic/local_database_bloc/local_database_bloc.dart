import 'dart:core';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../local_database/timer_database.dart';
import '../../main.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'local_database_repository.dart';
part 'local_database_event.dart';
part 'local_database_state.dart';

class LocalDatabaseBloc extends Bloc<LocalDatabaseEvent, LocalDatabaseState> {
  LocalDatabaseRepository repository;
  LocalDatabaseBloc(this.repository) : super(LocalDatabaseInitial()) {
    on<InsertDataEvent>(_insertData);
    on<GetSingleDataForTodayByIdEvent>(_singleTodayDtaById);
    on<GetSingleDataForInitialEvent>(_singleTimeForInitialSetup);
    on<CheckTableEmptyEvent>(_checkDatabaseEmpty);
    on<TodayAllDataEvent>(_getTodayData);
    on<CurrentMonthDataEvent>(_getCurrentMonthData);
    on<GetAllDataEvent>(_getAllData);
    on<UpdateIsSyncFlagEvent>(_updateIsSyncFlag);
  }

  Future<void> _insertData(
      LocalDatabaseEvent event, Emitter<LocalDatabaseState> emit) async {
    // if (event is FetchLocalDatabase) {
    emit(InsertDataLoading());

    try {
      final data = await LocalDatabaseRepository.insertTime(
          status: event.status,
          context: event.context,
          timeData: event.timeData,
          sessionTime: event.sessionTime,
          isSync: event.isSync);

      //preferenceManagerRepository.user = model.user;
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      /* prefs.setString(
          LocalStorageKeys.userData, jsonEncode(model.user));*/
      Logger.println('insert response from bloc:$data');
      if (data != null && data > 0) {
        emit(InsertDataLoaded(data: data, timeStatus: event.status));
      }
    } on ServiceException catch (e) {
      emit(InsertDataError(errors: e.message));
    }
  }

  Future<void> _checkDatabaseEmpty(
      LocalDatabaseEvent event, Emitter<LocalDatabaseState> emit) async {
    // if (event is FetchLocalDatabase) {
    emit(CheckTableEmptyLoading());

    try {
      //var data =  database?.countRows();//LocalDatabaseRepository.checkTableEmpty();

      //preferenceManagerRepository.user = model.user;
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      /* prefs.setString(
          LocalStorageKeys.userData, jsonEncode(model.user));*/
      // if(data){
      var count = database!.countRows();
      Logger.println('check table empty from bloc:$count');

      emit(CheckTableEmptyLoaded(count: count));
      //}
    } on ServiceException catch (e) {
      emit(CheckTableEmptyError(errors: e.message));
    }
  }

  Future<void> _singleTodayDtaById(
      LocalDatabaseEvent event, Emitter<LocalDatabaseState> emit) async {
    // if (event is FetchLocalDatabase) {
    emit(GetSingleDataForTodayByIdLoading());
    try {
      var data = await LocalDatabaseRepository.getSingleRecordForTodayById(
          timerStatus: event.status, userId: event.userId, isForInitial: false);
      if (data != null) {
        await data.first
            .then((value) => emit(GetSingleDataForTodayByIdLoaded(
                data: value, timeStatus: event.status)))
            .onError((error, stackTrace) => emit(GetSingleDataForTodayByIdError(
                errors: '$error', status: event.status)));
        Logger.println(
            'query gor get single record by id abd today date=$data');
      }
    } on ServiceException catch (e) {
      emit(GetSingleDataForTodayByIdError(
          errors: e.message, status: event.status));
    }
  }

  Future<void> _singleTimeForInitialSetup(
      LocalDatabaseEvent event, Emitter<LocalDatabaseState> emit) async {
    // if (event is FetchLocalDatabase) {
    emit(GetSingleDataForInitialLoading());
    try {
      var data = await LocalDatabaseRepository.getSingleRecordForTodayById(
          timerStatus: event.status, userId: event.userId, isForInitial: true);
      await data?.first
          .then((value) => emit(GetSingleDataForInitialLoaded(
              data: value, timeStatus: event.status)))
          .onError((error, stackTrace) => emit(GetSingleDataForInitialError(
              errors: '$error', status: event.status)));
    } on ServiceException catch (e) {
      emit(GetSingleDataForInitialError(
          errors: e.message, status: event.status));
    }
  }

  Future<void> _getTodayData(
      LocalDatabaseEvent event, Emitter<LocalDatabaseState> emit) async {
    // if (event is FetchLocalDatabase) {
    emit(TodayAllDataLoading());
    try {
      var data = await LocalDatabaseRepository.getTodayAllData(
          isWorkingTime: event.isWorkingTime, userId: event.userId);
      await data?.first
          .then((value) => emit(TodayAllDataLoaded(
              data: value, isWorkingTime: event.isWorkingTime)))
          .onError(
              (error, stackTrace) => emit(TodayAllDataError(errors: '$error')));
    } on ServiceException catch (e) {
      emit(TodayAllDataError(errors: e.message));
    }
  }

  Future<void> _getCurrentMonthData(
      LocalDatabaseEvent event, Emitter<LocalDatabaseState> emit) async {
    // if (event is FetchLocalDatabase) {
    emit(CurrentMonthDataLoading());
    try {
      var data = await LocalDatabaseRepository.getCurrentMonthData(
          isWorkingTime: event.isWorkingTime, userId: event.userId);
      await data?.first
          .then((value) => emit(CurrentMonthDataLoaded(
              data: value, isWorkingTime: event.isWorkingTime)))
          .onError((error, stackTrace) =>
              emit(CurrentMonthDataError(errors: '$error')));
    } on ServiceException catch (e) {
      emit(CurrentMonthDataError(errors: e.message));
    }
  }

  Future<void> _getAllData(
      LocalDatabaseEvent event, Emitter<LocalDatabaseState> emit) async {
    // if (event is FetchLocalDatabase) {
    emit(AllDataLoading());
    try {
      var data = await LocalDatabaseRepository.getAllData();
      List<TimerDetailData> userData = [];
      if (data != null && data.isNotEmpty) {
        for (var t in data) {
          if (t.employeeId == event.userId) {
            userData.add(t);
          }
        }
        emit(AllDataLoaded(data: userData));
      } else {
        emit(const AllDataError(errors: 'No records found'));
      }
      /*await data?.toList().then((value) => emit(AllDataLoaded(data: value
           */ /*data:value ,isWorkingTime:  event.isWorkingTime*/ /*))).onError((error, stackTrace) => emit(AllDataError(errors: '${error}')));*/
    } on ServiceException catch (e) {
      emit(AllDataError(errors: e.message));
    }
  }

  Future<void> _updateIsSyncFlag(
      LocalDatabaseEvent event, Emitter<LocalDatabaseState> emit) async {
    // if (event is FetchLocalDatabase) {
    emit(UpdateIsSyncFlagLoading());
    try {
      var data = await LocalDatabaseRepository.updateIsSyncFlagData(
        timer: event.timer,
        context: event.context,
        isSync: event.isSync,
      );
      if (data) {
        emit(const UpdateIsSyncFlagLoaded(isSync: true));
      } else {
        emit(const UpdateIsSyncFlagError(errors: 'No records found'));
      }
      /*await data?.toList().then((value) => emit(AllDataLoaded(data: value
           */ /*data:value ,isWorkingTime:  event.isWorkingTime*/ /*))).onError((error, stackTrace) => emit(AllDataError(errors: '${error}')));*/
    } on ServiceException catch (e) {
      emit(AllDataError(errors: e.message));
    }
  }
}
