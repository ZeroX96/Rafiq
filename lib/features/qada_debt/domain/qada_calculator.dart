class QadaCalculator {
  static const int daysInLunarYear = 354;
  static const int prayersPerDay = 5; // Fajr, Dhuhr, Asr, Maghrib, Isha

  /// Calculates total missed prayers based on duration.
  /// Returns a map of PrayerName -> Count
  Map<String, int> calculateDebtDetailed({
    int years = 0,
    int months = 0,
    int weeks = 0,
    int days = 0,
    String gender = 'Male',
    bool hasMenstruation = false,
    int menstruationDuration = 7,
  }) {
    // 1 Lunar Year = 354 days
    int totalDays =
        (years * daysInLunarYear) + (months * 29) + (weeks * 7) + days;

    // Subtract menstruation days
    if ((gender == 'Female' || gender == 'Girl' || gender == 'Woman') &&
        hasMenstruation) {
      // Approximate months in the missed period
      double totalMonths = totalDays / 29.5;
      int totalMenstruationDays = (totalMonths * menstruationDuration).round();
      totalDays -= totalMenstruationDays;
    }

    if (totalDays < 0) totalDays = 0;

    int totalPrayersPerType = totalDays; // 1 of each type per day

    return {
      'Fajr': totalPrayersPerType,
      'Dhuhr': totalPrayersPerType,
      'Asr': totalPrayersPerType,
      'Maghrib': totalPrayersPerType,
      'Isha': totalPrayersPerType,
      'Witr': totalPrayersPerType,
    };
  }

  Map<String, int> calculateDebtFromProfile({
    required DateTime dob,
    required int pubertyAge,
    required String gender,
    required bool hasMenstruation,
    int menstruationDuration = 7,
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

    // Subtract menstruation days for females
    if ((gender == 'Female' || gender == 'Girl' || gender == 'Woman') &&
        hasMenstruation) {
      // Approximate months passed
      final double months = totalDays / 30.0;
      final int totalMenstruationDays = (months * menstruationDuration).round();
      adjustedDays -= totalMenstruationDays;
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
