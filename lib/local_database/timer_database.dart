import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:oceanbit_timeclock/constant/api.dart';
import 'package:oceanbit_timeclock/utils/date_formatter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constant/strings.dart';
import '../utils/logger.dart';

part 'timer_database.g.dart';

@DriftDatabase(include: {'timer.drift'})
class MyTimerDatabase extends _$MyTimerDatabase {
  MyTimerDatabase() : super(_openConnection());

  MyTimerDatabase.forTesting(DatabaseConnection connection) : super(connection);
  @override
  int get schemaVersion => 1;

  Future<void> deleteEverything() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
      Logger.println('total tables:${allTables.length}');
    });
  }

  Expression<int> countRows() {
    return timerDetail.rowId.count();
  }

  Future<List<TimerDetailData>> getTimer() async {
    return await select(timerDetail).get();
  }

  Future<int> saveTimer(TimerDetailCompanion companion) async {
    return await into(timerDetail).insert(companion);
  }

  Future<int> deleteTimerById(int id) async {
    return (delete(timerDetail)..where((u) => u.timerId.equals(id))).go();
    // return (delete(timerDetail)..where(timerDetail.id.equals(id) as Expression<bool> Function(timerDetail tbl))).go();
  }

  Future<Stream<List<TimerDetailData>>> watchTimerWithId(
    String employeeId,
  ) async {
    return (select(
      timerDetail,
    )..where((timer) => timer.employeeId.equals(employeeId))).watch();
  }

  Stream<TimerDetailData?> getTodayTimeByEmpId(
    String employeeId,
    String timerStatus,
    bool isForInitial,
  ) {
    var dateTime = DateFormatter.formateDate(
      outputFormatter: 'yyyy-MM-dd',
      inputFormatter: 'yyyy-MM-dd HH:mm:ss',
      input: DateTime.now().toString(),
    );
    if (isForInitial) {
      final query = select(timerDetail)
        ..where((tbl) => tbl.employeeId.equals(employeeId))
        ..orderBy([
          (timer) =>
              OrderingTerm(expression: timer.timerId, mode: OrderingMode.desc),
        ])
        ..limit(1);
      return query.watchSingleOrNull();
    } else {
      final query = select(timerDetail)
        ..where(
          (timer) =>
              timer.employeeId.equals(employeeId) &
              timer.setDate.equals(DateTime.parse(dateTime)) &
              timer.timerType.equals(timerStatus),
        )
        ..orderBy([
          (timer) =>
              OrderingTerm(expression: timer.timerId, mode: OrderingMode.desc),
        ])
        ..limit(1);
      return query.watchSingleOrNull();
    }

    /*  var dateTime = DateFormatter.formateDate(
      outputFormatter: 'yyyy-MM-dd',
      inputFormatter: 'yyyy-MM-dd HH:mm:ss',
      input: DateTime.now().toString(),
    );
    */ /*  final query=await select(timerDetail)..orderBy([(timer) =>
        OrderingTerm(expression: timer.timerId, mode: OrderingMode.desc),])..limit(1);*/ /*
    final query = await select(timerDetail)
      ..where((timer) =>
          timer.employeeId.equals(employeeId) &
          timer.setDate.equals(DateTime.parse(
              dateTime)) */ /*& timer.timerType.equals(timer_status)*/ /*)
      ..orderBy([
        (timer) =>
            OrderingTerm(expression: timer.timerId, mode: OrderingMode.desc),
      ])
      ..limit(1);
    return query.watchSingle()?? null;*/
  }

  Future<Stream<List<TimerDetailData>>> getTodayTimeForTotal(
    String employeeId, {
    required bool isWorkingTime,
  }) async {
    var dateTime = DateFormatter.formateDate(
      outputFormatter: 'yyyy-MM-dd',
      inputFormatter: 'yyyy-MM-dd HH:mm:ss',
      input: DateTime.now().toString(),
    );
    /* final query=await select(timerDetailDemo)..orderBy([(timer) =>
        OrderingTerm(expression: timer.timerId, mode: OrderingMode.desc),])..limit(1);*/
    final query = select(timerDetail)
      ..where(
        (timer) =>
            timer.employeeId.equals(employeeId) &
            timer.setDate.equals(DateTime.parse(dateTime)) &
            (isWorkingTime
                ? (timer.timerType.equals(Strings.time_status[1]) |
                      timer.timerType.equals(Strings.time_status[3]))
                : timer.timerType.equals(Strings.time_status[2])),
      );
    return query.watch();
  }

  Future<Stream<List<TimerDetailData>>> getTimeForMonth(
    String employeeId, {
    required bool isWorkingTime,
  }) async {
    List<TimerDetailData> list = [];
    final query = select(timerDetail)
      ..where(
        (timer) =>
            timer.employeeId.equals(employeeId) &
            // timer.setDate.equals(DateTime.parse(dateTime)) &
            (isWorkingTime
                ? (timer.timerType.equals(Strings.time_status[1]) |
                      timer.timerType.equals(Strings.time_status[3]))
                : timer.timerType.equals(Strings.time_status[2])),
      );
    var data = query.watch();
    data.forEach((element) {
      for (var element in element) {
        if ('${element.setDate.year}-${element.setDate.month}' ==
            '${DateTime.now().year}-${DateTime.now().month}') {
          list.add(element);
        }
        Logger.println('query:::${element.sessionTime}');
      }
    });
    return query.watch();
  }

  Future<List<TimerDetailData>> watchTimerWithUserIdAndDate(String id) async {
    /*return (select(timerDetail)..where((timer)=>(timer.employeeId.equals(id) && timer.setDate.equals(DateTime.now()))..orderBy([(timer) => OrderingTerm(mode: OrderingMode.desc,expression: (timer.setTime))]))
        .watch();*/

    final query = select(timerDetail).join([
      innerJoin(
        timerDetail,
        timerDetail.employeeId.equals(id),
        useColumns: false,
      ),
    ])..where(timerDetail.setDate.equals(DateTime.now()));

    return query.map((row) => row.readTable(timerDetail)).get();
  }

  Future<int> deleteAllTimer() async {
    return await delete(timerDetail).go();
  }

  Future<bool> updateTimer({
    required int timerId,
    required String employeeId,
    required String empName,
    required String timerType,
    required String time,
    required DateTime date,
    required String sessionTime,
    bool isSync = false,
  }) async {
    return update(timerDetail).replace(
      TimerDetailData(
        timerId: timerId,
        employeeId: employeeId,
        employeeName: empName,
        timerType: timerType,
        setTime: time /*DateFormatter.formateDate(
            outputFormatter: 'HH:mm:ss',
            inputFormatter: 'yyyy-MM-dd HH:mm:ss',
            input: timeData.toString().toString())*/,
        setDate: date,
        isSync: isSync == false ? 0 : 1,
        sessionTime: sessionTime,
      ),
    );
    /*    return await update(timerDetail).replace(timerDetailCompanion(
        name: companion.name,
      price: companion.price,
      description: companion.description,
      image: companion.image
    ));*/
    //}
  }

  /* static final StateProvider<MyTimerDatabase> provider = StateProvider((ref) {
    final database = MyTimerDatabase();
    ref.onDispose(database.close);

    return database;
  });*/
}

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'timer_detail.db'));
//     return NativeDatabase(file);
//   });
// }

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final oldDbPath = p.join(dbFolder.path, Api.databaseSmall);
    final newDbPath = p.join(dbFolder.path, Api.newDatabaseSmall);

    final oldDbFile = File(oldDbPath);
    final newDbFile = File(newDbPath);

    // Rename the DB file if the old one exists and new one doesn't
    if (await oldDbFile.exists() && !(await newDbFile.exists())) {
      await oldDbFile.rename(newDbPath);
    }

    return NativeDatabase(File(newDbPath));
  });
}
