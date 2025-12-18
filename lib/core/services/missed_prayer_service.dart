import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MissedPrayerService {
  static const List<String> fardPrayers = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  static const List<String> sunnahPrayers = ['Sunrise', 'Shafaa', 'Witr'];

  /// Checks for missed prayers from previous days and adds them to Qada debt.
  /// Returns the number of prayers added to debt.
  static Future<int> checkAndAddMissedPrayers() async {
    final prefs = await SharedPreferences.getInstance();

    // Get the last checked date
    final lastChecked = prefs.getString('last_missed_prayer_check');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // If we already checked today, skip
    if (lastChecked == today) {
      return 0;
    }

    // Get user preference for tracking Sunnah
    final trackSunnah = prefs.getBool('track_sunnah_debt') ?? false;

    // Determine which prayers to check
    final prayersToCheck = [...fardPrayers];
    if (trackSunnah) {
      prayersToCheck.addAll(sunnahPrayers);
    }

    int addedToDebt = 0;

    // Check yesterday's prayers (or multiple days if app wasn't opened)
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayKey = DateFormat('yyyy-MM-dd').format(yesterday);

    // Only check if we have a valid last check date or it's first time
    if (lastChecked == null || lastChecked != yesterdayKey) {
      for (String prayer in prayersToCheck) {
        // Check if prayer was done yesterday
        final wasDone =
            prefs.getBool('prayer_${yesterdayKey}_$prayer') ?? false;
        final status =
            prefs.getString('prayer_status_${yesterdayKey}_$prayer') ?? 'None';

        // If not done and status is None or Missed, add to debt
        if (!wasDone && (status == 'None' || status == 'Missed')) {
          // Only add Fard prayers to debt by default, Sunnah only if user opted in
          if (fardPrayers.contains(prayer) || trackSunnah) {
            final currentDebt = prefs.getInt('qada_debt_$prayer') ?? 0;
            await prefs.setInt('qada_debt_$prayer', currentDebt + 1);
            addedToDebt++;
          }
        }
      }
    }

    // Update last checked date
    await prefs.setString('last_missed_prayer_check', today);

    return addedToDebt;
  }

  /// Resets the last checked date (for testing purposes)
  static Future<void> resetLastCheckedDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_missed_prayer_check');
  }
}
