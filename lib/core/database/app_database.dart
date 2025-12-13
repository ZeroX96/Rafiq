import 'package:drift/drift.dart';
import 'package:rafiq/core/database/connection/connection.dart' as impl;

part 'app_database.g.dart';

class Prayers extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get prayerName => text()(); // Fajr, Dhuhr, Asr, Maghrib, Isha
  TextColumn get status => text()(); // OnTime, Late, Missed, Excused
  DateTimeColumn get timestamp => dateTime().nullable()();
}

class Qada extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get prayerName => text().unique()();
  IntColumn get totalDebt => integer().withDefault(const Constant(0))();
  IntColumn get paidCount => integer().withDefault(const Constant(0))();
}

class Azkar extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  IntColumn get target => integer().withDefault(const Constant(100))();
  TextColumn get category => text().nullable()();
}

@DriftDatabase(tables: [Prayers, Qada, Azkar])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;
}
