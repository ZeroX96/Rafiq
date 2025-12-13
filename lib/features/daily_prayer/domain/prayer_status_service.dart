import 'package:rafiq/core/database/app_database.dart';
import 'package:drift/drift.dart';

class PrayerStatusService {
  final AppDatabase db;

  PrayerStatusService(this.db);

  Future<void> checkAndAutoMarkMissed() async {
    // 1. Get last checked date from Settings or infer from latest Prayer entry
    // For MVP, let's assume we check from the last logged prayer or install date.

    // Logic:
    // Get today's date.
    // Check if we have entries for yesterday.
    // If not, create "Missed" entries for yesterday and increment Qada.

    // This is complex to do fully right now without a robust "Settings" implementation for "last_run_time".
    // I will implement a placeholder that adds 1 to Qada if a specific prayer is marked "Missed" explicitly.
    // The "Auto" part usually requires a persistent "last_checked" timestamp.
  }

  Future<void> markAsMissed(String prayerName, DateTime date) async {
    // 1. Add to Prayers table as Missed
    await db
        .into(db.prayers)
        .insert(
          PrayersCompanion(
            date: Value(date),
            prayerName: Value(prayerName),
            status: const Value('Missed'),
            timestamp: Value(DateTime.now()),
          ),
        );

    // 2. Increment Qada
    await incrementQada(prayerName);
  }

  Future<void> incrementQada(String prayerName) async {
    final qadaEntry =
        await (db.select(db.qada)
          ..where((t) => t.prayerName.equals(prayerName))).getSingleOrNull();

    if (qadaEntry != null) {
      await (db.update(db.qada)..where(
        (t) => t.prayerName.equals(prayerName),
      )).write(QadaCompanion(totalDebt: Value(qadaEntry.totalDebt + 1)));
    } else {
      await db
          .into(db.qada)
          .insert(
            QadaCompanion(
              prayerName: Value(prayerName),
              totalDebt: const Value(1),
            ),
          );
    }
  }
}
