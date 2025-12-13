import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

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
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
