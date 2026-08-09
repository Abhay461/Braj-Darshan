import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/yatra_plan.dart';
import '../../shared/providers/yatra_planner_provider.dart';

class YatraPlannerScreen extends ConsumerStatefulWidget {
  const YatraPlannerScreen({super.key});

  @override
  ConsumerState<YatraPlannerScreen> createState() => _YatraPlannerScreenState();
}

class _YatraPlannerScreenState extends ConsumerState<YatraPlannerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isCalendarView = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(yatraPlannerProvider);

    final upcomingPlans = plans.where((p) => !p.isCompleted).toList()
      ..sort((a, b) => a.plannedDate.compareTo(b.plannedDate));
    final completedPlans = plans.where((p) => p.isCompleted).toList()
      ..sort((a, b) => b.plannedDate.compareTo(a.plannedDate));

    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
          ),
          title: Text(
            'My Yatra Plan',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            IconButton(
              tooltip: _isCalendarView ? 'Switch to List View' : 'Switch to Calendar View',
              icon: Icon(_isCalendarView ? Icons.view_list_outlined : Icons.calendar_month_outlined),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _isCalendarView = !_isCalendarView);
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            tabs: [
              Tab(text: 'Upcoming (${upcomingPlans.length})'),
              Tab(text: 'History (${completedPlans.length})'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildUpcomingTab(context, upcomingPlans),
            _buildHistoryTab(context, completedPlans),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTab(BuildContext context, List<YatraPlan> plans) {
    if (plans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Icon(
                  Icons.event_note_outlined,
                  size: 40,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No Upcoming Yatra Planned',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Open any temple screen and tap "+ Plan Yatra Visit" to set scheduled alerts and darshan reminders.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isCalendarView) {
      final selectedDatePlans = _selectedDay == null
          ? plans
          : plans.where((p) => isSameDay(p.plannedDate, _selectedDay)).toList();

      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Theme.of(context).colorScheme.outline),
              ),
              child: TableCalendar(
                firstDay: DateTime.now().subtract(const Duration(days: 30)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) {
                  return plans.where((p) => isSameDay(p.plannedDate, day)).toList();
                },
                onDaySelected: (selectedDay, focusedDay) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: selectedDatePlans.map((plan) => _buildPlanCard(context, plan)).toList(),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return _buildPlanCard(context, plan);
      },
    );
  }

  Widget _buildHistoryTab(BuildContext context, List<YatraPlan> completedPlans) {
    if (completedPlans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'No Completed Yatra Yet',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Mark your planned visits as completed after Darshan to save them in history.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedPlans.length,
      itemBuilder: (context, index) {
        final plan = completedPlans[index];
        return _buildPlanCard(context, plan, isHistory: true);
      },
    );
  }

  Widget _buildPlanCard(BuildContext context, YatraPlan plan, {bool isHistory = false}) {
    final dateStr = '${plan.plannedDate.day}/${plan.plannedDate.month}/${plan.plannedDate.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isHistory ? Icons.check_circle_outline : Icons.temple_hindu_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.templeName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.event_outlined,
                          size: 13,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Visit Date: $dateStr',
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isHistory ? 'Mark as Pending' : 'Mark Completed',
                icon: Icon(
                  isHistory ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isHistory
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.read(yatraPlannerProvider.notifier).toggleCompleted(plan.id);
                },
              ),
              IconButton(
                tooltip: 'Delete Plan',
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.read(yatraPlannerProvider.notifier).removePlan(plan.id);
                },
              ),
            ],
          ),
          if (!isHistory && (plan.oneDayBeforeReminder || plan.reminderOption != 'none')) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  size: 13,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Alerts Active: ${plan.oneDayBeforeReminder ? "1-Day Evening" : ""}${plan.reminderOption != "none" ? " • ${plan.reminderOption == "1_hour" ? "1 Hr" : "30m"} Pre-Darshan" : ""}',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

