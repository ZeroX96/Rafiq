import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize(
    void Function(NotificationResponse)? onNotificationResponse,
  ) async {
    if (_isInitialized) return;

    try {
      tz_data.initializeTimeZones();
      // Use UTC as fallback for now to avoid build errors with flutter_timezone
      tz.setLocalLocation(tz.getLocation('UTC'));
      debugPrint('NotificationService: Timezone initialized to UTC (Fallback)');

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/launcher_icon',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final initialized = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: onNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      _isInitialized = initialized ?? false;
      debugPrint('NotificationService: Plugin initialized: $_isInitialized');

      // Create high importance channels for Android
      final androidPlugin =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'prayer_channel',
            'Prayer Times',
            description: 'Notifications for prayer times',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            showBadge: true,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'pre_prayer_channel',
            'Pre-Prayer Reminders',
            description: 'Reminders before prayer times',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'post_prayer_channel',
            'Prayer Check Reminders',
            description: 'Reminders to check if you prayed',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'test_channel',
            'Test Notifications',
            description: 'Used for testing notifications',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );
        debugPrint('NotificationService: Android channels created');
      }
    } catch (e) {
      debugPrint('NotificationService: Initialization error: $e');
    }
  }

  Future<void> requestPermissions() async {
    try {
      final androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final granted =
          await androidImplementation?.requestNotificationsPermission();
      debugPrint('NotificationService: Android permission granted: $granted');

      // Also request exact alarm permission for Android 13+
      await androidImplementation?.requestExactAlarmsPermission();
    } catch (e) {
      debugPrint('NotificationService: Permission request error: $e');
    }
  }

  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // Don't schedule if in the past
    if (scheduledTime.isBefore(DateTime.now())) return;

    const androidDetails = AndroidNotificationDetails(
      'prayer_channel',
      'Prayer Times',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      actions: [
        AndroidNotificationAction('prayed', 'Prayed'),
        AndroidNotificationAction('remind_later', 'Remind in 30m'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'prayer_category',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime.toUtc(), tz.UTC),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Schedule a pre-prayer reminder notification (gentle, no actions)
  Future<void> schedulePrePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) return;

    const androidDetails = AndroidNotificationDetails(
      'pre_prayer_channel',
      'Pre-Prayer Reminders',
      channelDescription: 'Reminders before prayer times',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'pre_prayer_category',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime.toUtc(), tz.UTC),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedule a post-prayer check notification (with action to mark prayer)
  Future<void> schedulePostPrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) return;

    const androidDetails = AndroidNotificationDetails(
      'post_prayer_channel',
      'Prayer Check Reminders',
      channelDescription: 'Reminders to check if you prayed',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      actions: [
        AndroidNotificationAction('prayed', 'Yes, I prayed'),
        AndroidNotificationAction('missed', 'I missed it'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'post_prayer_category',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime.toUtc(), tz.UTC),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Show an immediate notification for testing
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Used for testing notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(id, title, body, details, payload: payload);
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle background actions if needed
  print('Background action: ${notificationResponse.actionId}');
}
