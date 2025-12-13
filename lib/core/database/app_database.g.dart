// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PrayersTable extends Prayers with TableInfo<$PrayersTable, Prayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prayerNameMeta = const VerificationMeta(
    'prayerName',
  );
  @override
  late final GeneratedColumn<String> prayerName = GeneratedColumn<String>(
    'prayer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    prayerName,
    status,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Prayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('prayer_name')) {
      context.handle(
        _prayerNameMeta,
        prayerName.isAcceptableOrUnknown(data['prayer_name']!, _prayerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_prayerNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prayer(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      prayerName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}prayer_name'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      ),
    );
  }

  @override
  $PrayersTable createAlias(String alias) {
    return $PrayersTable(attachedDatabase, alias);
  }
}

class Prayer extends DataClass implements Insertable<Prayer> {
  final int id;
  final DateTime date;
  final String prayerName;
  final String status;
  final DateTime? timestamp;
  const Prayer({
    required this.id,
    required this.date,
    required this.prayerName,
    required this.status,
    this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['prayer_name'] = Variable<String>(prayerName);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || timestamp != null) {
      map['timestamp'] = Variable<DateTime>(timestamp);
    }
    return map;
  }

  PrayersCompanion toCompanion(bool nullToAbsent) {
    return PrayersCompanion(
      id: Value(id),
      date: Value(date),
      prayerName: Value(prayerName),
      status: Value(status),
      timestamp:
          timestamp == null && nullToAbsent
              ? const Value.absent()
              : Value(timestamp),
    );
  }

  factory Prayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prayer(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      prayerName: serializer.fromJson<String>(json['prayerName']),
      status: serializer.fromJson<String>(json['status']),
      timestamp: serializer.fromJson<DateTime?>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'prayerName': serializer.toJson<String>(prayerName),
      'status': serializer.toJson<String>(status),
      'timestamp': serializer.toJson<DateTime?>(timestamp),
    };
  }

  Prayer copyWith({
    int? id,
    DateTime? date,
    String? prayerName,
    String? status,
    Value<DateTime?> timestamp = const Value.absent(),
  }) => Prayer(
    id: id ?? this.id,
    date: date ?? this.date,
    prayerName: prayerName ?? this.prayerName,
    status: status ?? this.status,
    timestamp: timestamp.present ? timestamp.value : this.timestamp,
  );
  Prayer copyWithCompanion(PrayersCompanion data) {
    return Prayer(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      prayerName:
          data.prayerName.present ? data.prayerName.value : this.prayerName,
      status: data.status.present ? data.status.value : this.status,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prayer(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('prayerName: $prayerName, ')
          ..write('status: $status, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, prayerName, status, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prayer &&
          other.id == this.id &&
          other.date == this.date &&
          other.prayerName == this.prayerName &&
          other.status == this.status &&
          other.timestamp == this.timestamp);
}

class PrayersCompanion extends UpdateCompanion<Prayer> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> prayerName;
  final Value<String> status;
  final Value<DateTime?> timestamp;
  const PrayersCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.prayerName = const Value.absent(),
    this.status = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  PrayersCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String prayerName,
    required String status,
    this.timestamp = const Value.absent(),
  }) : date = Value(date),
       prayerName = Value(prayerName),
       status = Value(status);
  static Insertable<Prayer> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? prayerName,
    Expression<String>? status,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (prayerName != null) 'prayer_name': prayerName,
      if (status != null) 'status': status,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  PrayersCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? prayerName,
    Value<String>? status,
    Value<DateTime?>? timestamp,
  }) {
    return PrayersCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      prayerName: prayerName ?? this.prayerName,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (prayerName.present) {
      map['prayer_name'] = Variable<String>(prayerName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayersCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('prayerName: $prayerName, ')
          ..write('status: $status, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $QadaTable extends Qada with TableInfo<$QadaTable, QadaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QadaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _prayerNameMeta = const VerificationMeta(
    'prayerName',
  );
  @override
  late final GeneratedColumn<String> prayerName = GeneratedColumn<String>(
    'prayer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _totalDebtMeta = const VerificationMeta(
    'totalDebt',
  );
  @override
  late final GeneratedColumn<int> totalDebt = GeneratedColumn<int>(
    'total_debt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paidCountMeta = const VerificationMeta(
    'paidCount',
  );
  @override
  late final GeneratedColumn<int> paidCount = GeneratedColumn<int>(
    'paid_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, prayerName, totalDebt, paidCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'qada';
  @override
  VerificationContext validateIntegrity(
    Insertable<QadaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prayer_name')) {
      context.handle(
        _prayerNameMeta,
        prayerName.isAcceptableOrUnknown(data['prayer_name']!, _prayerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_prayerNameMeta);
    }
    if (data.containsKey('total_debt')) {
      context.handle(
        _totalDebtMeta,
        totalDebt.isAcceptableOrUnknown(data['total_debt']!, _totalDebtMeta),
      );
    }
    if (data.containsKey('paid_count')) {
      context.handle(
        _paidCountMeta,
        paidCount.isAcceptableOrUnknown(data['paid_count']!, _paidCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QadaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QadaData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      prayerName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}prayer_name'],
          )!,
      totalDebt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_debt'],
          )!,
      paidCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}paid_count'],
          )!,
    );
  }

  @override
  $QadaTable createAlias(String alias) {
    return $QadaTable(attachedDatabase, alias);
  }
}

class QadaData extends DataClass implements Insertable<QadaData> {
  final int id;
  final String prayerName;
  final int totalDebt;
  final int paidCount;
  const QadaData({
    required this.id,
    required this.prayerName,
    required this.totalDebt,
    required this.paidCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prayer_name'] = Variable<String>(prayerName);
    map['total_debt'] = Variable<int>(totalDebt);
    map['paid_count'] = Variable<int>(paidCount);
    return map;
  }

  QadaCompanion toCompanion(bool nullToAbsent) {
    return QadaCompanion(
      id: Value(id),
      prayerName: Value(prayerName),
      totalDebt: Value(totalDebt),
      paidCount: Value(paidCount),
    );
  }

  factory QadaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QadaData(
      id: serializer.fromJson<int>(json['id']),
      prayerName: serializer.fromJson<String>(json['prayerName']),
      totalDebt: serializer.fromJson<int>(json['totalDebt']),
      paidCount: serializer.fromJson<int>(json['paidCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'prayerName': serializer.toJson<String>(prayerName),
      'totalDebt': serializer.toJson<int>(totalDebt),
      'paidCount': serializer.toJson<int>(paidCount),
    };
  }

  QadaData copyWith({
    int? id,
    String? prayerName,
    int? totalDebt,
    int? paidCount,
  }) => QadaData(
    id: id ?? this.id,
    prayerName: prayerName ?? this.prayerName,
    totalDebt: totalDebt ?? this.totalDebt,
    paidCount: paidCount ?? this.paidCount,
  );
  QadaData copyWithCompanion(QadaCompanion data) {
    return QadaData(
      id: data.id.present ? data.id.value : this.id,
      prayerName:
          data.prayerName.present ? data.prayerName.value : this.prayerName,
      totalDebt: data.totalDebt.present ? data.totalDebt.value : this.totalDebt,
      paidCount: data.paidCount.present ? data.paidCount.value : this.paidCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QadaData(')
          ..write('id: $id, ')
          ..write('prayerName: $prayerName, ')
          ..write('totalDebt: $totalDebt, ')
          ..write('paidCount: $paidCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, prayerName, totalDebt, paidCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QadaData &&
          other.id == this.id &&
          other.prayerName == this.prayerName &&
          other.totalDebt == this.totalDebt &&
          other.paidCount == this.paidCount);
}

class QadaCompanion extends UpdateCompanion<QadaData> {
  final Value<int> id;
  final Value<String> prayerName;
  final Value<int> totalDebt;
  final Value<int> paidCount;
  const QadaCompanion({
    this.id = const Value.absent(),
    this.prayerName = const Value.absent(),
    this.totalDebt = const Value.absent(),
    this.paidCount = const Value.absent(),
  });
  QadaCompanion.insert({
    this.id = const Value.absent(),
    required String prayerName,
    this.totalDebt = const Value.absent(),
    this.paidCount = const Value.absent(),
  }) : prayerName = Value(prayerName);
  static Insertable<QadaData> custom({
    Expression<int>? id,
    Expression<String>? prayerName,
    Expression<int>? totalDebt,
    Expression<int>? paidCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prayerName != null) 'prayer_name': prayerName,
      if (totalDebt != null) 'total_debt': totalDebt,
      if (paidCount != null) 'paid_count': paidCount,
    });
  }

  QadaCompanion copyWith({
    Value<int>? id,
    Value<String>? prayerName,
    Value<int>? totalDebt,
    Value<int>? paidCount,
  }) {
    return QadaCompanion(
      id: id ?? this.id,
      prayerName: prayerName ?? this.prayerName,
      totalDebt: totalDebt ?? this.totalDebt,
      paidCount: paidCount ?? this.paidCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (prayerName.present) {
      map['prayer_name'] = Variable<String>(prayerName.value);
    }
    if (totalDebt.present) {
      map['total_debt'] = Variable<int>(totalDebt.value);
    }
    if (paidCount.present) {
      map['paid_count'] = Variable<int>(paidCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QadaCompanion(')
          ..write('id: $id, ')
          ..write('prayerName: $prayerName, ')
          ..write('totalDebt: $totalDebt, ')
          ..write('paidCount: $paidCount')
          ..write(')'))
        .toString();
  }
}

class $AzkarTable extends Azkar with TableInfo<$AzkarTable, AzkarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AzkarTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, content, count, target, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'azkar';
  @override
  VerificationContext validateIntegrity(
    Insertable<AzkarData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AzkarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AzkarData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      content:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content'],
          )!,
      count:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}count'],
          )!,
      target:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}target'],
          )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
    );
  }

  @override
  $AzkarTable createAlias(String alias) {
    return $AzkarTable(attachedDatabase, alias);
  }
}

class AzkarData extends DataClass implements Insertable<AzkarData> {
  final int id;
  final String content;
  final int count;
  final int target;
  final String? category;
  const AzkarData({
    required this.id,
    required this.content,
    required this.count,
    required this.target,
    this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['count'] = Variable<int>(count);
    map['target'] = Variable<int>(target);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  AzkarCompanion toCompanion(bool nullToAbsent) {
    return AzkarCompanion(
      id: Value(id),
      content: Value(content),
      count: Value(count),
      target: Value(target),
      category:
          category == null && nullToAbsent
              ? const Value.absent()
              : Value(category),
    );
  }

  factory AzkarData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AzkarData(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      count: serializer.fromJson<int>(json['count']),
      target: serializer.fromJson<int>(json['target']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'count': serializer.toJson<int>(count),
      'target': serializer.toJson<int>(target),
      'category': serializer.toJson<String?>(category),
    };
  }

  AzkarData copyWith({
    int? id,
    String? content,
    int? count,
    int? target,
    Value<String?> category = const Value.absent(),
  }) => AzkarData(
    id: id ?? this.id,
    content: content ?? this.content,
    count: count ?? this.count,
    target: target ?? this.target,
    category: category.present ? category.value : this.category,
  );
  AzkarData copyWithCompanion(AzkarCompanion data) {
    return AzkarData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      count: data.count.present ? data.count.value : this.count,
      target: data.target.present ? data.target.value : this.target,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AzkarData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('count: $count, ')
          ..write('target: $target, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, count, target, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AzkarData &&
          other.id == this.id &&
          other.content == this.content &&
          other.count == this.count &&
          other.target == this.target &&
          other.category == this.category);
}

class AzkarCompanion extends UpdateCompanion<AzkarData> {
  final Value<int> id;
  final Value<String> content;
  final Value<int> count;
  final Value<int> target;
  final Value<String?> category;
  const AzkarCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.count = const Value.absent(),
    this.target = const Value.absent(),
    this.category = const Value.absent(),
  });
  AzkarCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.count = const Value.absent(),
    this.target = const Value.absent(),
    this.category = const Value.absent(),
  }) : content = Value(content);
  static Insertable<AzkarData> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<int>? count,
    Expression<int>? target,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (count != null) 'count': count,
      if (target != null) 'target': target,
      if (category != null) 'category': category,
    });
  }

  AzkarCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<int>? count,
    Value<int>? target,
    Value<String?>? category,
  }) {
    return AzkarCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      count: count ?? this.count,
      target: target ?? this.target,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AzkarCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('count: $count, ')
          ..write('target: $target, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PrayersTable prayers = $PrayersTable(this);
  late final $QadaTable qada = $QadaTable(this);
  late final $AzkarTable azkar = $AzkarTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [prayers, qada, azkar];
}

typedef $$PrayersTableCreateCompanionBuilder =
    PrayersCompanion Function({
      Value<int> id,
      required DateTime date,
      required String prayerName,
      required String status,
      Value<DateTime?> timestamp,
    });
typedef $$PrayersTableUpdateCompanionBuilder =
    PrayersCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> prayerName,
      Value<String> status,
      Value<DateTime?> timestamp,
    });

class $$PrayersTableFilterComposer
    extends Composer<_$AppDatabase, $PrayersTable> {
  $$PrayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prayerName => $composableBuilder(
    column: $table.prayerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayersTable> {
  $$PrayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prayerName => $composableBuilder(
    column: $table.prayerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayersTable> {
  $$PrayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get prayerName => $composableBuilder(
    column: $table.prayerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$PrayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrayersTable,
          Prayer,
          $$PrayersTableFilterComposer,
          $$PrayersTableOrderingComposer,
          $$PrayersTableAnnotationComposer,
          $$PrayersTableCreateCompanionBuilder,
          $$PrayersTableUpdateCompanionBuilder,
          (Prayer, BaseReferences<_$AppDatabase, $PrayersTable, Prayer>),
          Prayer,
          PrefetchHooks Function()
        > {
  $$PrayersTableTableManager(_$AppDatabase db, $PrayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PrayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PrayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PrayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> prayerName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> timestamp = const Value.absent(),
              }) => PrayersCompanion(
                id: id,
                date: date,
                prayerName: prayerName,
                status: status,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String prayerName,
                required String status,
                Value<DateTime?> timestamp = const Value.absent(),
              }) => PrayersCompanion.insert(
                id: id,
                date: date,
                prayerName: prayerName,
                status: status,
                timestamp: timestamp,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrayersTable,
      Prayer,
      $$PrayersTableFilterComposer,
      $$PrayersTableOrderingComposer,
      $$PrayersTableAnnotationComposer,
      $$PrayersTableCreateCompanionBuilder,
      $$PrayersTableUpdateCompanionBuilder,
      (Prayer, BaseReferences<_$AppDatabase, $PrayersTable, Prayer>),
      Prayer,
      PrefetchHooks Function()
    >;
typedef $$QadaTableCreateCompanionBuilder =
    QadaCompanion Function({
      Value<int> id,
      required String prayerName,
      Value<int> totalDebt,
      Value<int> paidCount,
    });
typedef $$QadaTableUpdateCompanionBuilder =
    QadaCompanion Function({
      Value<int> id,
      Value<String> prayerName,
      Value<int> totalDebt,
      Value<int> paidCount,
    });

class $$QadaTableFilterComposer extends Composer<_$AppDatabase, $QadaTable> {
  $$QadaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prayerName => $composableBuilder(
    column: $table.prayerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDebt => $composableBuilder(
    column: $table.totalDebt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidCount => $composableBuilder(
    column: $table.paidCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QadaTableOrderingComposer extends Composer<_$AppDatabase, $QadaTable> {
  $$QadaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prayerName => $composableBuilder(
    column: $table.prayerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDebt => $composableBuilder(
    column: $table.totalDebt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidCount => $composableBuilder(
    column: $table.paidCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QadaTableAnnotationComposer
    extends Composer<_$AppDatabase, $QadaTable> {
  $$QadaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prayerName => $composableBuilder(
    column: $table.prayerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDebt =>
      $composableBuilder(column: $table.totalDebt, builder: (column) => column);

  GeneratedColumn<int> get paidCount =>
      $composableBuilder(column: $table.paidCount, builder: (column) => column);
}

class $$QadaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QadaTable,
          QadaData,
          $$QadaTableFilterComposer,
          $$QadaTableOrderingComposer,
          $$QadaTableAnnotationComposer,
          $$QadaTableCreateCompanionBuilder,
          $$QadaTableUpdateCompanionBuilder,
          (QadaData, BaseReferences<_$AppDatabase, $QadaTable, QadaData>),
          QadaData,
          PrefetchHooks Function()
        > {
  $$QadaTableTableManager(_$AppDatabase db, $QadaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$QadaTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$QadaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$QadaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> prayerName = const Value.absent(),
                Value<int> totalDebt = const Value.absent(),
                Value<int> paidCount = const Value.absent(),
              }) => QadaCompanion(
                id: id,
                prayerName: prayerName,
                totalDebt: totalDebt,
                paidCount: paidCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String prayerName,
                Value<int> totalDebt = const Value.absent(),
                Value<int> paidCount = const Value.absent(),
              }) => QadaCompanion.insert(
                id: id,
                prayerName: prayerName,
                totalDebt: totalDebt,
                paidCount: paidCount,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QadaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QadaTable,
      QadaData,
      $$QadaTableFilterComposer,
      $$QadaTableOrderingComposer,
      $$QadaTableAnnotationComposer,
      $$QadaTableCreateCompanionBuilder,
      $$QadaTableUpdateCompanionBuilder,
      (QadaData, BaseReferences<_$AppDatabase, $QadaTable, QadaData>),
      QadaData,
      PrefetchHooks Function()
    >;
typedef $$AzkarTableCreateCompanionBuilder =
    AzkarCompanion Function({
      Value<int> id,
      required String content,
      Value<int> count,
      Value<int> target,
      Value<String?> category,
    });
typedef $$AzkarTableUpdateCompanionBuilder =
    AzkarCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<int> count,
      Value<int> target,
      Value<String?> category,
    });

class $$AzkarTableFilterComposer extends Composer<_$AppDatabase, $AzkarTable> {
  $$AzkarTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AzkarTableOrderingComposer
    extends Composer<_$AppDatabase, $AzkarTable> {
  $$AzkarTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AzkarTableAnnotationComposer
    extends Composer<_$AppDatabase, $AzkarTable> {
  $$AzkarTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$AzkarTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AzkarTable,
          AzkarData,
          $$AzkarTableFilterComposer,
          $$AzkarTableOrderingComposer,
          $$AzkarTableAnnotationComposer,
          $$AzkarTableCreateCompanionBuilder,
          $$AzkarTableUpdateCompanionBuilder,
          (AzkarData, BaseReferences<_$AppDatabase, $AzkarTable, AzkarData>),
          AzkarData,
          PrefetchHooks Function()
        > {
  $$AzkarTableTableManager(_$AppDatabase db, $AzkarTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AzkarTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AzkarTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AzkarTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<String?> category = const Value.absent(),
              }) => AzkarCompanion(
                id: id,
                content: content,
                count: count,
                target: target,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                Value<int> count = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<String?> category = const Value.absent(),
              }) => AzkarCompanion.insert(
                id: id,
                content: content,
                count: count,
                target: target,
                category: category,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AzkarTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AzkarTable,
      AzkarData,
      $$AzkarTableFilterComposer,
      $$AzkarTableOrderingComposer,
      $$AzkarTableAnnotationComposer,
      $$AzkarTableCreateCompanionBuilder,
      $$AzkarTableUpdateCompanionBuilder,
      (AzkarData, BaseReferences<_$AppDatabase, $AzkarTable, AzkarData>),
      AzkarData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PrayersTableTableManager get prayers =>
      $$PrayersTableTableManager(_db, _db.prayers);
  $$QadaTableTableManager get qada => $$QadaTableTableManager(_db, _db.qada);
  $$AzkarTableTableManager get azkar =>
      $$AzkarTableTableManager(_db, _db.azkar);
}
