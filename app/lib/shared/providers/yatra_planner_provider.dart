import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/yatra_plan.dart';
import '../../core/services/notification_service.dart';

class YatraPlannerNotifier extends StateNotifier<List<YatraPlan>> {
  static const String _prefsKey = 'braj_yatra_plans_v1';
  final NotificationService _notificationService = NotificationService();

  YatraPlannerNotifier() : super([]) {
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        final plans = decoded.map((e) => YatraPlan.fromJson(e as Map<String, dynamic>)).toList();
        state = plans;
      }
    } catch (_) {}
  }

  Future<void> _savePlans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.map((e) => e.toJson()).toList());
      await prefs.setString(_prefsKey, jsonString);
    } catch (_) {}
  }

  Future<void> addPlan(YatraPlan plan) async {
    state = [...state, plan];
    await _savePlans();
    await _notificationService.scheduleYatraNotifications(plan);
  }

  Future<void> removePlan(String planId) async {
    state = state.where((p) => p.id != planId).toList();
    await _savePlans();
    await _notificationService.cancelPlanNotifications(planId);
  }

  Future<void> toggleCompleted(String planId) async {
    state = state.map((p) {
      if (p.id == planId) {
        final updated = p.copyWith(isCompleted: !p.isCompleted);
        if (updated.isCompleted) {
          _notificationService.cancelPlanNotifications(planId);
        } else {
          _notificationService.scheduleYatraNotifications(updated);
        }
        return updated;
      }
      return p;
    }).toList();
    await _savePlans();
  }

  Future<void> updatePlanSettings({
    required String planId,
    required String reminderOption,
    required bool oneDayBeforeReminder,
    required String notes,
  }) async {
    state = state.map((p) {
      if (p.id == planId) {
        final updated = p.copyWith(
          reminderOption: reminderOption,
          oneDayBeforeReminder: oneDayBeforeReminder,
          notes: notes,
        );
        _notificationService.scheduleYatraNotifications(updated);
        return updated;
      }
      return p;
    }).toList();
    await _savePlans();
  }
}

final yatraPlannerProvider = StateNotifierProvider<YatraPlannerNotifier, List<YatraPlan>>((ref) {
  return YatraPlannerNotifier();
});
