import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/yatra_plan.dart';
import '../../core/services/hive_service.dart';
import '../../core/services/notification_service.dart';

class YatraPlannerNotifier extends StateNotifier<List<YatraPlan>> {
  final NotificationService _notificationService = NotificationService();

  YatraPlannerNotifier() : super([]) {
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final rawList = HiveService.getYatraPlansRaw();
      final plans = rawList.map((e) => YatraPlan.fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
      state = plans;
    } catch (e) {
      debugPrint('YatraPlannerNotifier._loadPlans error: $e');
    }
  }

  Future<void> _savePlans() async {
    try {
      await HiveService.clearYatraPlans();
      for (final plan in state) {
        await HiveService.saveYatraPlanRaw(plan.id, jsonEncode(plan.toJson()));
      }
    } catch (e) {
      debugPrint('YatraPlannerNotifier._savePlans error: $e');
    }
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
