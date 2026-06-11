import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/local_database/timer_database.dart';

import '../bloc_logic/common_repositories/preference_repository.dart';
import '../main.dart';
import '../utils/date_formatter.dart';
import '../utils/logger.dart';

class CustomQueries {
  static Future<int> insertTime(
      {required String status,
      required BuildContext context,
      required DateTime timeData,
      required String sessionTime,
      bool isSync = false}) async {
    var result = await database!.saveTimer(TimerDetailCompanion(
        employeeId: Value(
            context.read<PreferenceManagerRepository>().user!.employeeId!),
        employeeName: Value(
          '${context.read<PreferenceManagerRepository>().user!.firstName!} ${context.read<PreferenceManagerRepository>().user!.lastName!}',
        ),
        timerType: Value(status),
        // timeData: Value(timeData ?? DateTime.now()),
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

  /*static double _convertTimeToSecond(String string){
    double totalSecond=double.parse(string.split(":")[2]);
    totalSecond=totalSecond+(double.parse(string.split(":")[1])*60)+((double.parse(string.split(":")[0])*60)*60);
    return totalSecond;
  }*/

  static Future<List> getTimerData() async {
    var result = await database!.getTimer();
    return result;
  }

  static Future<int> deleteTimerDataById(int id) async {
    var result = await database!.deleteTimerById(id);
    // return (delete(productDetail)..where(productDetail.id.equals(id) as Expression<bool> Function(ProductDetail tbl))).go();
    return result;
  }

  static Future<Stream<List<TimerDetailData>>> watchTimerDataWithId(
      int id, String userId, String date) async {
    var result = await database!.watchTimerWithId(userId);
    return result;
  }

  /* static Future<Stream<TimerDetailData>?> watchTimerDataWithIdAndDate(
       String userId,String timerStatus) async {
    var result = await database!.getTodayTimeByEmpId(userId,timerStatus);
  print(result.first.toString());


    return result;
  }*/
  static Future<Stream<List<TimerDetailData>>> getTimeForMonthTotal(
      String userId, bool? isWorkingTime) async {
    var result =
        await database!.getTimeForMonth(userId, isWorkingTime: isWorkingTime!);
    Logger.println('session time : $result');
    return result;
  }

  static Future<Stream<List<TimerDetailData>>> getDataForTotalTime(
      String userId,
      {required bool isWorkingTime}) async {
    var result = await database!
        .getTodayTimeForTotal(userId, isWorkingTime: isWorkingTime);
    //print(result.first.toString());

    return result;
  }

  static Future<int> deleteAllTimerData() async {
    var result = await database!.deleteAllTimer();
    return result;
  }

  static Future<bool> updateTimerData(
      {required int timerId,
      required String image,
      required String timerType,
      DateTime? date,
      required String time,
      required String sessionTime,
      required BuildContext context,
      required bool isSync}) async {
    var result = await database!.updateTimer(
        timerId: timerId,
        employeeId:
            context.read<PreferenceManagerRepository>().user!.employeeId!,
        empName:
            '${context.read<PreferenceManagerRepository>().user!.firstName!} ${context.read<PreferenceManagerRepository>().user!.lastName!}',
        timerType: timerType,
        date: date!,
        time: time, //?? DateTime.now(),
        sessionTime: sessionTime,
        isSync: isSync);
    return result;
  }
}
