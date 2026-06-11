// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_database.dart';

// ignore_for_file: type=lint
class TimerDetail extends Table with TableInfo<TimerDetail, TimerDetailData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TimerDetail(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _timerIdMeta = const VerificationMeta(
    'timerId',
  );
  late final GeneratedColumn<int> timerId = GeneratedColumn<int>(
    'timer_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _employeeNameMeta = const VerificationMeta(
    'employeeName',
  );
  late final GeneratedColumn<String> employeeName = GeneratedColumn<String>(
    'employee_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _timerTypeMeta = const VerificationMeta(
    'timerType',
  );
  late final GeneratedColumn<String> timerType = GeneratedColumn<String>(
    'timer_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (timer_type == \'Initial In\' OR timer_type == \'Inter Out\' OR timer_type == \'Inter In\' OR timer_type == \'Final Out\')',
  );
  static const VerificationMeta _setTimeMeta = const VerificationMeta(
    'setTime',
  );
  late final GeneratedColumn<String> setTime = GeneratedColumn<String>(
    'set_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sessionTimeMeta = const VerificationMeta(
    'sessionTime',
  );
  late final GeneratedColumn<String> sessionTime = GeneratedColumn<String>(
    'session_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _setDateMeta = const VerificationMeta(
    'setDate',
  );
  late final GeneratedColumn<DateTime> setDate = GeneratedColumn<DateTime>(
    'set_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _isSyncMeta = const VerificationMeta('isSync');
  late final GeneratedColumn<int> isSync = GeneratedColumn<int>(
    'isSync',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (isSync == 1 OR isSync == 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    timerId,
    employeeId,
    employeeName,
    timerType,
    setTime,
    sessionTime,
    setDate,
    isSync,
  ];
  @override
  String get aliasedName => _alias ?? Api.database;
  @override
  String get actualTableName => Api.database;
  @override
  VerificationContext validateIntegrity(
    Insertable<TimerDetailData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('timer_id')) {
      context.handle(
        _timerIdMeta,
        timerId.isAcceptableOrUnknown(data['timer_id']!, _timerIdMeta),
      );
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('employee_name')) {
      context.handle(
        _employeeNameMeta,
        employeeName.isAcceptableOrUnknown(
          data['employee_name']!,
          _employeeNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_employeeNameMeta);
    }
    if (data.containsKey('timer_type')) {
      context.handle(
        _timerTypeMeta,
        timerType.isAcceptableOrUnknown(data['timer_type']!, _timerTypeMeta),
      );
    }
    if (data.containsKey('set_time')) {
      context.handle(
        _setTimeMeta,
        setTime.isAcceptableOrUnknown(data['set_time']!, _setTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_setTimeMeta);
    }
    if (data.containsKey('session_time')) {
      context.handle(
        _sessionTimeMeta,
        sessionTime.isAcceptableOrUnknown(
          data['session_time']!,
          _sessionTimeMeta,
        ),
      );
    }
    if (data.containsKey('set_date')) {
      context.handle(
        _setDateMeta,
        setDate.isAcceptableOrUnknown(data['set_date']!, _setDateMeta),
      );
    } else if (isInserting) {
      context.missing(_setDateMeta);
    }
    if (data.containsKey('isSync')) {
      context.handle(
        _isSyncMeta,
        isSync.isAcceptableOrUnknown(data['isSync']!, _isSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {timerId};
  @override
  TimerDetailData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimerDetailData(
      timerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timer_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      employeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_name'],
      )!,
      timerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timer_type'],
      ),
      setTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_time'],
      )!,
      sessionTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_time'],
      ),
      setDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}set_date'],
      )!,
      isSync: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isSync'],
      ),
    );
  }

  @override
  TimerDetail createAlias(String alias) {
    return TimerDetail(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TimerDetailData extends DataClass implements Insertable<TimerDetailData> {
  final int timerId;
  final String employeeId;
  final String employeeName;
  final String? timerType;
  final String setTime;
  final String? sessionTime;
  final DateTime setDate;
  final int? isSync;
  const TimerDetailData({
    required this.timerId,
    required this.employeeId,
    required this.employeeName,
    this.timerType,
    required this.setTime,
    this.sessionTime,
    required this.setDate,
    this.isSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['timer_id'] = Variable<int>(timerId);
    map['employee_id'] = Variable<String>(employeeId);
    map['employee_name'] = Variable<String>(employeeName);
    if (!nullToAbsent || timerType != null) {
      map['timer_type'] = Variable<String>(timerType);
    }
    map['set_time'] = Variable<String>(setTime);
    if (!nullToAbsent || sessionTime != null) {
      map['session_time'] = Variable<String>(sessionTime);
    }
    map['set_date'] = Variable<DateTime>(setDate);
    if (!nullToAbsent || isSync != null) {
      map['isSync'] = Variable<int>(isSync);
    }
    return map;
  }

  TimerDetailCompanion toCompanion(bool nullToAbsent) {
    return TimerDetailCompanion(
      timerId: Value(timerId),
      employeeId: Value(employeeId),
      employeeName: Value(employeeName),
      timerType: timerType == null && nullToAbsent
          ? const Value.absent()
          : Value(timerType),
      setTime: Value(setTime),
      sessionTime: sessionTime == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionTime),
      setDate: Value(setDate),
      isSync: isSync == null && nullToAbsent
          ? const Value.absent()
          : Value(isSync),
    );
  }

  factory TimerDetailData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimerDetailData(
      timerId: serializer.fromJson<int>(json['timer_id']),
      employeeId: serializer.fromJson<String>(json['employee_id']),
      employeeName: serializer.fromJson<String>(json['employee_name']),
      timerType: serializer.fromJson<String?>(json['timer_type']),
      setTime: serializer.fromJson<String>(json['set_time']),
      sessionTime: serializer.fromJson<String?>(json['session_time']),
      setDate: serializer.fromJson<DateTime>(json['set_date']),
      isSync: serializer.fromJson<int?>(json['isSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'timer_id': serializer.toJson<int>(timerId),
      'employee_id': serializer.toJson<String>(employeeId),
      'employee_name': serializer.toJson<String>(employeeName),
      'timer_type': serializer.toJson<String?>(timerType),
      'set_time': serializer.toJson<String>(setTime),
      'session_time': serializer.toJson<String?>(sessionTime),
      'set_date': serializer.toJson<DateTime>(setDate),
      'isSync': serializer.toJson<int?>(isSync),
    };
  }

  TimerDetailData copyWith({
    int? timerId,
    String? employeeId,
    String? employeeName,
    Value<String?> timerType = const Value.absent(),
    String? setTime,
    Value<String?> sessionTime = const Value.absent(),
    DateTime? setDate,
    Value<int?> isSync = const Value.absent(),
  }) => TimerDetailData(
    timerId: timerId ?? this.timerId,
    employeeId: employeeId ?? this.employeeId,
    employeeName: employeeName ?? this.employeeName,
    timerType: timerType.present ? timerType.value : this.timerType,
    setTime: setTime ?? this.setTime,
    sessionTime: sessionTime.present ? sessionTime.value : this.sessionTime,
    setDate: setDate ?? this.setDate,
    isSync: isSync.present ? isSync.value : this.isSync,
  );
  @override
  String toString() {
    return (StringBuffer('TimerDetailData(')
          ..write('timerId: $timerId, ')
          ..write('employeeId: $employeeId, ')
          ..write('employeeName: $employeeName, ')
          ..write('timerType: $timerType, ')
          ..write('setTime: $setTime, ')
          ..write('sessionTime: $sessionTime, ')
          ..write('setDate: $setDate, ')
          ..write('isSync: $isSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    timerId,
    employeeId,
    employeeName,
    timerType,
    setTime,
    sessionTime,
    setDate,
    isSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimerDetailData &&
          other.timerId == this.timerId &&
          other.employeeId == this.employeeId &&
          other.employeeName == this.employeeName &&
          other.timerType == this.timerType &&
          other.setTime == this.setTime &&
          other.sessionTime == this.sessionTime &&
          other.setDate == this.setDate &&
          other.isSync == this.isSync);
}

class TimerDetailCompanion extends UpdateCompanion<TimerDetailData> {
  final Value<int> timerId;
  final Value<String> employeeId;
  final Value<String> employeeName;
  final Value<String?> timerType;
  final Value<String> setTime;
  final Value<String?> sessionTime;
  final Value<DateTime> setDate;
  final Value<int?> isSync;
  const TimerDetailCompanion({
    this.timerId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.employeeName = const Value.absent(),
    this.timerType = const Value.absent(),
    this.setTime = const Value.absent(),
    this.sessionTime = const Value.absent(),
    this.setDate = const Value.absent(),
    this.isSync = const Value.absent(),
  });
  TimerDetailCompanion.insert({
    this.timerId = const Value.absent(),
    required String employeeId,
    required String employeeName,
    this.timerType = const Value.absent(),
    required String setTime,
    this.sessionTime = const Value.absent(),
    required DateTime setDate,
    this.isSync = const Value.absent(),
  }) : employeeId = Value(employeeId),
       employeeName = Value(employeeName),
       setTime = Value(setTime),
       setDate = Value(setDate);
  static Insertable<TimerDetailData> custom({
    Expression<int>? timerId,
    Expression<String>? employeeId,
    Expression<String>? employeeName,
    Expression<String>? timerType,
    Expression<String>? setTime,
    Expression<String>? sessionTime,
    Expression<DateTime>? setDate,
    Expression<int>? isSync,
  }) {
    return RawValuesInsertable({
      if (timerId != null) 'timer_id': timerId,
      if (employeeId != null) 'employee_id': employeeId,
      if (employeeName != null) 'employee_name': employeeName,
      if (timerType != null) 'timer_type': timerType,
      if (setTime != null) 'set_time': setTime,
      if (sessionTime != null) 'session_time': sessionTime,
      if (setDate != null) 'set_date': setDate,
      if (isSync != null) 'isSync': isSync,
    });
  }

  TimerDetailCompanion copyWith({
    Value<int>? timerId,
    Value<String>? employeeId,
    Value<String>? employeeName,
    Value<String?>? timerType,
    Value<String>? setTime,
    Value<String?>? sessionTime,
    Value<DateTime>? setDate,
    Value<int?>? isSync,
  }) {
    return TimerDetailCompanion(
      timerId: timerId ?? this.timerId,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      timerType: timerType ?? this.timerType,
      setTime: setTime ?? this.setTime,
      sessionTime: sessionTime ?? this.sessionTime,
      setDate: setDate ?? this.setDate,
      isSync: isSync ?? this.isSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (timerId.present) {
      map['timer_id'] = Variable<int>(timerId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (employeeName.present) {
      map['employee_name'] = Variable<String>(employeeName.value);
    }
    if (timerType.present) {
      map['timer_type'] = Variable<String>(timerType.value);
    }
    if (setTime.present) {
      map['set_time'] = Variable<String>(setTime.value);
    }
    if (sessionTime.present) {
      map['session_time'] = Variable<String>(sessionTime.value);
    }
    if (setDate.present) {
      map['set_date'] = Variable<DateTime>(setDate.value);
    }
    if (isSync.present) {
      map['isSync'] = Variable<int>(isSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimerDetailCompanion(')
          ..write('timerId: $timerId, ')
          ..write('employeeId: $employeeId, ')
          ..write('employeeName: $employeeName, ')
          ..write('timerType: $timerType, ')
          ..write('setTime: $setTime, ')
          ..write('sessionTime: $sessionTime, ')
          ..write('setDate: $setDate, ')
          ..write('isSync: $isSync')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyTimerDatabase extends GeneratedDatabase {
  _$MyTimerDatabase(QueryExecutor e) : super(e);
  late final TimerDetail timerDetail = TimerDetail(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [timerDetail];
}
