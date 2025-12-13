class QadaCalculator {
  static const int daysInLunarYear = 354;
  static const int prayersPerDay = 5; // Fajr, Dhuhr, Asr, Maghrib, Isha

  /// Calculates total missed prayers based on years missed.
  /// Returns a map of PrayerName -> Count
  Map<String, int> calculateDebt({
    required int yearsMissed,
    int monthsMissed = 0,
    int daysMissed = 0,
  }) {
    // 1 Lunar Year = 354 days
    // 1 Lunar Month = 29.5 days (approx 30 for safety or 29) - let's use 30 for safety or 29.5
    // Actually, user said "assume lunar years".

    int totalDays =
        (yearsMissed * daysInLunarYear) + (monthsMissed * 29) + daysMissed;
    int totalPrayersPerType = totalDays; // 1 of each type per day

    return {
      'Fajr': totalPrayersPerType,
      'Dhuhr': totalPrayersPerType,
      'Asr': totalPrayersPerType,
      'Maghrib': totalPrayersPerType,
      'Isha': totalPrayersPerType,
      'Witr':
          totalPrayersPerType, // Witr is Wajib in Hanafi, maybe optional? User didn't specify Witr but usually Qada includes it for Hanafis.
      // I'll stick to 5 fardh for now unless configured.
    };
  }

  Map<String, int> calculateDebtFromProfile({
    required DateTime dob,
    required int pubertyAge,
    required String gender,
    required bool hasMenstruation,
  }) {
    final DateTime pubertyDate = DateTime(
      dob.year + pubertyAge,
      dob.month,
      dob.day,
    );
    final DateTime now = DateTime.now();

    if (now.isBefore(pubertyDate)) {
      return {
        'Fajr': 0,
        'Dhuhr': 0,
        'Asr': 0,
        'Maghrib': 0,
        'Isha': 0,
        'Witr': 0,
      };
    }

    final int totalDays = now.difference(pubertyDate).inDays;
    int adjustedDays = totalDays;

    // Subtract menstruation days for females (approx 7 days per month)
    if (gender == 'Female' && hasMenstruation) {
      // Approximate months passed
      final double months = totalDays / 30.0;
      final int menstruationDays = (months * 7).round();
      adjustedDays -= menstruationDays;
    }

    if (adjustedDays < 0) adjustedDays = 0;

    return {
      'Fajr': adjustedDays,
      'Dhuhr': adjustedDays,
      'Asr': adjustedDays,
      'Maghrib': adjustedDays,
      'Isha': adjustedDays,
      'Witr': adjustedDays,
    };
  }
}
