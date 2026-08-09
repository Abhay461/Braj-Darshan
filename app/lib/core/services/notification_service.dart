import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../shared/models/yatra_plan.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(initSettings);
      _isInitialized = true;
      await requestPermissions();
    } catch (e) {
      debugPrint('NotificationService.initialize error: $e');
    }
  }

  Future<bool> requestPermissions() async {
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  Future<void> showInstantNotification({required String title, required String body}) async {
    await initialize();
    const androidDetails = AndroidNotificationDetails(
      'braj_yatra_channel',
      'Yatra & Darshan Reminders',
      channelDescription: 'Notifications for planned temple visits and darshan timings',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());

    try {
      await _notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        details,
      );
    } catch (e) {
      debugPrint('showInstantNotification error: $e');
    }
  }

  Future<void> scheduleYatraNotifications(YatraPlan plan) async {
    await initialize();
    final baseId = plan.id.hashCode.abs();

    const androidDetails = AndroidNotificationDetails(
      'braj_yatra_channel',
      'Yatra & Darshan Reminders',
      channelDescription: 'Notifications for planned temple visits and darshan timings',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());

    final now = DateTime.now();

    // Instant confirmation pop-up alert when plan is created
    await showInstantNotification(
      title: '🚩 Yatra Visit Scheduled!',
      body: 'Darshan reminders set for ${plan.templeName} on ${plan.plannedDate.day}/${plan.plannedDate.month}/${plan.plannedDate.year}.',
    );

    // 1. One Day Before Evening Reminder (8:00 PM evening prior to visit)
    if (plan.oneDayBeforeReminder) {
      final oneDayBefore = DateTime(
        plan.plannedDate.year,
        plan.plannedDate.month,
        plan.plannedDate.day - 1,
        20, // 8:00 PM
        0,
      );

      if (oneDayBefore.isAfter(now)) {
        await _safeZonedSchedule(
          id: baseId,
          title: '🚩 Tomorrow Yatra Alert!',
          body: 'Tomorrow is your planned visit to ${plan.templeName}. Pack your essentials for Darshan!',
          scheduledDate: tz.TZDateTime.from(oneDayBefore, tz.local),
          details: details,
        );
      }
    }

    // 2. Visit Day Morning Reminder (8:00 AM)
    final morningReminderDate = DateTime(
      plan.plannedDate.year,
      plan.plannedDate.month,
      plan.plannedDate.day,
      8, // 8:00 AM
      0,
    );

    if (morningReminderDate.isAfter(now)) {
      await _safeZonedSchedule(
        id: baseId + 1,
        title: '🌸 Jay Shri Krishna! Today Yatra Day',
        body: 'Today is your planned visit to ${plan.templeName}. Wish you a divine Darshan!',
        scheduledDate: tz.TZDateTime.from(morningReminderDate, tz.local),
        details: details,
      );
    }

    // 3. Pre-Darshan Opening Reminder (30 mins or 1 hr before opening)
    if (plan.openingTime.isNotEmpty && plan.reminderOption != 'none') {
      final openingDt = _parseTimeToDateTime(plan.plannedDate, plan.openingTime);
      if (openingDt != null) {
        final minsBefore = plan.reminderOption == '1_hour' ? 60 : 30;
        final alertTime = openingDt.subtract(Duration(minutes: minsBefore));

        if (alertTime.isAfter(now)) {
          await _safeZonedSchedule(
            id: baseId + 2,
            title: '🔔 Darshan Opening Reminder',
            body: '${plan.templeName} opens for Darshan in $minsBefore minutes (${plan.openingTime})!',
            scheduledDate: tz.TZDateTime.from(alertTime, tz.local),
            details: details,
          );
        }
      }
    }

    // 4. Pre-Darshan Closing Reminder (30 mins before closing)
    if (plan.closingTime.isNotEmpty && plan.reminderOption != 'none') {
      final closingDt = _parseTimeToDateTime(plan.plannedDate, plan.closingTime);
      if (closingDt != null) {
        final alertTime = closingDt.subtract(const Duration(minutes: 30));

        if (alertTime.isAfter(now)) {
          await _safeZonedSchedule(
            id: baseId + 3,
            title: '⏳ Rajbhog Closing Reminder',
            body: '${plan.templeName} closes soon in 30 minutes for Rajbhog (${plan.closingTime})!',
            scheduledDate: tz.TZDateTime.from(alertTime, tz.local),
            details: details,
          );
        }
      }
    }
  }

  Future<void> _safeZonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails details,
  }) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      try {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (err) {
        debugPrint('Notification schedule error: $err');
      }
    }
  }

  Future<void> cancelPlanNotifications(String planId) async {
    await initialize();
    final baseId = planId.hashCode.abs();
    await _notificationsPlugin.cancel(baseId);
    await _notificationsPlugin.cancel(baseId + 1);
    await _notificationsPlugin.cancel(baseId + 2);
    await _notificationsPlugin.cancel(baseId + 3);
  }

  DateTime? _parseTimeToDateTime(DateTime baseDate, String timeStr) {
    try {
      final clean = timeStr.trim().toUpperCase();
      final isPm = clean.endsWith('PM');
      final isAm = clean.endsWith('AM');

      String timeDigits = clean.replaceAll(RegExp(r'[A-Z\s]'), '');
      final parts = timeDigits.split(':');
      if (parts.length < 2) return null;

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      if (isPm && hour < 12) hour += 12;
      if (isAm && hour == 12) hour = 0;

      return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
    } catch (_) {
      return null;
    }
  }
}
