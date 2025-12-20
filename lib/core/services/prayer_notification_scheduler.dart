import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rafiq/core/services/notification_service.dart';
import 'package:rafiq/core/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to schedule prayer notifications automatically
class PrayerNotificationScheduler {
  static const List<String> fardPrayers = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  static const List<String> sunnahPrayers = ['Sunrise', 'Shafaa', 'Witr'];

  /// Unique ID generation for notifications
  static int _getPrayerNotificationId(String prayer) => prayer.hashCode;
  static int _getPreReminderNotificationId(String prayer) =>
      prayer.hashCode + 1000;
  static int _getPostCheckNotificationId(String prayer) =>
      prayer.hashCode + 2000;

  /// Schedule all prayer notifications for today
  static Future<void> scheduleAllPrayerNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if notifications are enabled
    final notificationsEnabled =
        prefs.getBool('prayer_notifications_enabled') ?? true;
    if (!notificationsEnabled) {
      debugPrint('Prayer notifications are disabled');
      return;
    }

    // Get user location for prayer times (using keys from SettingsService)
    final lat = prefs.getDouble('selected_lat');
    final lng = prefs.getDouble('selected_lng');

    if (lat == null || lng == null) {
      debugPrint('No location set, cannot schedule prayer notifications');
      return;
    }

    // Calculate prayer times
    final coordinates = Coordinates(lat, lng);

    // Use Muslim World League as default method
    final params = CalculationMethod.muslim_world_league.getParameters();

    // Set Madhab based on user preference
    final userMadhab = prefs.getString('profile_madhab') ?? 'Hanafi';
    if (userMadhab.toLowerCase().contains('shafi')) {
      params.madhab = Madhab.shafi;
    } else {
      params.madhab = Madhab.hanafi;
    }

    final date = DateComponents.from(DateTime.now());
    final prayerTimes = PrayerTimes(coordinates, date, params);

    // Get user preferences
    final preReminderMinutes =
        prefs.getInt('pre_prayer_reminder_minutes') ?? 10;
    final postCheckMinutes = prefs.getInt('post_prayer_check_minutes') ?? 20;
    final includeSunnah = prefs.getBool('sunnah_notifications_enabled') ?? true;

    // Schedule Fard prayers
    await _schedulePrayerNotification(
      'Fajr',
      prayerTimes.fajr,
      prefs,
      preReminderMinutes,
      postCheckMinutes,
    );
    await _schedulePrayerNotification(
      'Dhuhr',
      prayerTimes.dhuhr,
      prefs,
      preReminderMinutes,
      postCheckMinutes,
    );
    await _schedulePrayerNotification(
      'Asr',
      prayerTimes.asr,
      prefs,
      preReminderMinutes,
      postCheckMinutes,
    );
    await _schedulePrayerNotification(
      'Maghrib',
      prayerTimes.maghrib,
      prefs,
      preReminderMinutes,
      postCheckMinutes,
    );
    await _schedulePrayerNotification(
      'Isha',
      prayerTimes.isha,
      prefs,
      preReminderMinutes,
      postCheckMinutes,
    );

    // Schedule Sunnah prayers if enabled
    if (includeSunnah) {
      await _schedulePrayerNotification(
        'Sunrise',
        prayerTimes.sunrise,
        prefs,
        preReminderMinutes,
        postCheckMinutes,
      );

      // Shafaa and Witr are after Isha
      final shafaaTime = prayerTimes.isha.add(const Duration(minutes: 30));
      final witrTime = prayerTimes.isha.add(const Duration(minutes: 45));

      await _schedulePrayerNotification(
        'Shafaa',
        shafaaTime,
        prefs,
        preReminderMinutes,
        postCheckMinutes,
      );
      await _schedulePrayerNotification(
        'Witr',
        witrTime,
        prefs,
        preReminderMinutes,
        postCheckMinutes,
      );
    }

    // Save last scheduled date
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('last_notification_schedule_date', today);

    debugPrint('All prayer notifications scheduled for $today');
  }

  /// Schedule a single prayer notification with pre-reminder and post-check
  static Future<void> _schedulePrayerNotification(
    String prayer,
    DateTime prayerTime,
    SharedPreferences prefs,
    int preReminderMinutes,
    int postCheckMinutes,
  ) async {
    final notificationService = NotificationService();
    final now = DateTime.now();

    // 1. Schedule pre-prayer reminder (if time allows)
    if (preReminderMinutes > 0) {
      final preReminderTime = prayerTime.subtract(
        Duration(minutes: preReminderMinutes),
      );
      if (preReminderTime.isAfter(now)) {
        await notificationService.schedulePrePrayerNotification(
          id: _getPreReminderNotificationId(prayer),
          title: '$prayer in $preReminderMinutes minutes',
          body: 'Prepare for $prayer prayer',
          scheduledTime: preReminderTime,
          payload: '${prayer}_pre_reminder',
        );
        debugPrint(
          'Scheduled pre-reminder for $prayer at ${DateFormat.Hm().format(preReminderTime)}',
        );
      }
    }

    // 2. Schedule prayer time notification
    if (prayerTime.isAfter(now)) {
      await notificationService.schedulePrayerNotification(
        id: _getPrayerNotificationId(prayer),
        title: '$prayer Prayer Time',
        body: 'It\'s time to pray $prayer',
        scheduledTime: prayerTime,
        payload: prayer,
      );
      debugPrint(
        'Scheduled $prayer notification at ${DateFormat.Hm().format(prayerTime)}',
      );
    }

    // 3. Schedule post-prayer check (if time allows)
    if (postCheckMinutes > 0) {
      final postCheckTime = prayerTime.add(Duration(minutes: postCheckMinutes));
      if (postCheckTime.isAfter(now)) {
        // Check if prayer was already marked as done
        final today = DateFormat('yyyy-MM-dd').format(now);
        final alreadyPrayed = prefs.getBool('prayer_${today}_$prayer') ?? false;

        if (!alreadyPrayed) {
          await notificationService.schedulePostPrayerNotification(
            id: _getPostCheckNotificationId(prayer),
            title: 'Did you pray $prayer?',
            body: 'Mark your $prayer prayer status',
            scheduledTime: postCheckTime,
            payload: '${prayer}_post_check',
          );
          debugPrint(
            'Scheduled post-check for $prayer at ${DateFormat.Hm().format(postCheckTime)}',
          );
        }
      }
    }
  }

  /// Cancel all scheduled prayer notifications
  static Future<void> cancelAllPrayerNotifications() async {
    final notificationService = NotificationService();

    for (final prayer in [...fardPrayers, ...sunnahPrayers]) {
      await notificationService.cancelNotification(
        _getPrayerNotificationId(prayer),
      );
      await notificationService.cancelNotification(
        _getPreReminderNotificationId(prayer),
      );
      await notificationService.cancelNotification(
        _getPostCheckNotificationId(prayer),
      );
    }

    debugPrint('All prayer notifications cancelled');
  }

  /// Reschedule all notifications (call at midnight or after settings change)
  static Future<void> rescheduleAll() async {
    await cancelAllPrayerNotifications();
    await scheduleAllPrayerNotifications();
  }

  /// Check if notifications need to be rescheduled today
  static Future<bool> needsRescheduling() async {
    final prefs = await SharedPreferences.getInstance();
    final lastScheduled = prefs.getString('last_notification_schedule_date');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return lastScheduled != today;
  }
}
