import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/common_repositories/preference_repository.dart';
import '../../local_database/timer_database.dart';
import '../../main.dart';
import '../../utils/date_formatter.dart';

class LocalDatabaseRepository {
  static final LocalDatabaseRepository localDatabaseRepository =
      LocalDatabaseRepository._();
  LocalDatabaseRepository._();

  factory LocalDatabaseRepository() {
    return localDatabaseRepository;
  }

  static Future<int?> insertTime(
      {required String status,
      required BuildContext context,
      required DateTime timeData,
      required String sessionTime,
      bool isSync = false}) async {
    var result = await database?.saveTimer(TimerDetailCompanion(
        employeeId: Value(
            context.read<PreferenceManagerRepository>().user!.employeeId!),
        employeeName: Value(
            '${context.read<PreferenceManagerRepository>().user!.firstName!} ${context.read<PreferenceManagerRepository>().user!.lastName!}'),
        timerType: Value(status),
        setTime: Value(DateFormatter.formateDate(
                outputFormatter: 'HH:mm:ss',
                inputFormatter: 'yyyy-MM-dd HH:mm:ss',
                input: timeData.toString())
            .toString()),
        setDate: Value(DateTime.parse(DateFormatter.formateDate(
            outputFormatter: 'yyyy-MM-dd',
            inputFormatter: 'yyyy-MM-dd HH:mm:ss',
            input: timeData.toString()))),
        sessionTime: Value(sessionTime),
        isSync: Value(isSync == false ? 0 : 1)));

    return result;
  }

  static Future<Stream<TimerDetailData?>?> getSingleRecordForTodayById(
      {userId, timerStatus, required bool isForInitial}) async {
    var result =
        database?.getTodayTimeByEmpId(userId, timerStatus, isForInitial);
    return result;
  }

  static Future<Stream<List<TimerDetailData>>?> getTodayAllData(
      {userId, isWorkingTime}) async {
    var result = await database?.getTodayTimeForTotal(userId,
        isWorkingTime: isWorkingTime);
    return result;
  }

  static Future<Stream<List<TimerDetailData>>?> getCurrentMonthData(
      {userId, isWorkingTime}) async {
    var result =
        await database?.getTimeForMonth(userId, isWorkingTime: isWorkingTime);
    return result;
  }

  static Future<List<TimerDetailData>?> getAllData() async {
    var result = await database?.getTimer();
    return result;
  }

  static Future<bool> updateIsSyncFlagData(
      {required TimerDetailData timer,
      required BuildContext context,
      required bool isSync}) async {
    var result = await database!.updateTimer(
        timerId: timer.timerId,
        employeeId:
            context.read<PreferenceManagerRepository>().user!.employeeId!,
        empName: timer.employeeName,
        //'${context.read<PreferenceManagerRepository>().user!.firstName!} ${context.read<PreferenceManagerRepository>().user!.lastName!}',
        date: timer.setDate,
        timerType: timer.timerType!,
        time: timer.setTime, //timeData ?? DateTime.now(),
        sessionTime: timer.sessionTime!,
        isSync: isSync);
    return result;
  }
}
