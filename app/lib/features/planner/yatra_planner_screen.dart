import 'package:flutter/material.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final plans = ref.watch(yatraPlannerProvider);

    final upcomingPlans = plans.where((p) => !p.isCompleted).toList()
      ..sort((a, b) => a.plannedDate.compareTo(b.plannedDate));
    final completedPlans = plans.where((p) => p.isCompleted).toList()
      ..sort((a, b) => b.plannedDate.compareTo(a.plannedDate));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121110) : const Color(0xFFFAF8F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1A1817) : const Color(0xFFF3EFEA),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Yatra Plan',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF18181B),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            tooltip: _isCalendarView ? 'Switch to List View' : 'Switch to Calendar View',
            icon: Icon(_isCalendarView ? Icons.view_list_outlined : Icons.calendar_month_outlined),
            onPressed: () {
              setState(() => _isCalendarView = !_isCalendarView);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: isDark ? Colors.white : const Color(0xFF18181B),
          labelColor: isDark ? Colors.white : const Color(0xFF18181B),
          unselectedLabelColor: const Color(0xFF71717A),
          tabs: [
            Tab(text: 'Upcoming (${upcomingPlans.length})'),
            Tab(text: 'History (${completedPlans.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // -------------------------------------------------------------------
          // TAB 1: Upcoming Yatra Visits
          // -------------------------------------------------------------------
          _buildUpcomingTab(context, upcomingPlans, isDark),

          // -------------------------------------------------------------------
          // TAB 2: Completed Yatra History
          // -------------------------------------------------------------------
          _buildHistoryTab(context, completedPlans, isDark),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab(BuildContext context, List<YatraPlan> plans, bool isDark) {
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
                  color: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.event_note_outlined, size: 40, color: Color(0xFF71717A)),
              ),
              const SizedBox(height: 16),
              Text(
                'No Upcoming Yatra Planned',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF18181B),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Open any temple screen and tap "+ Plan Yatra Visit" to set scheduled alerts and darshan reminders.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
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
                color: isDark ? const Color(0xFF1A1817) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? const Color(0xFF2C2826) : const Color(0xFFE8E4DF)),
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
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(color: Color(0xFFE56B00), shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(color: Color(0xFF18181B), shape: BoxShape.circle),
                  markerDecoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: selectedDatePlans.map((plan) => _buildPlanCard(context, plan, isDark)).toList(),
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
        return _buildPlanCard(context, plan, isDark);
      },
    );
  }

  Widget _buildHistoryTab(BuildContext context, List<YatraPlan> completedPlans, bool isDark) {
    if (completedPlans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.history_outlined, size: 40, color: Color(0xFF71717A)),
              const SizedBox(height: 12),
              Text(
                'No Completed Yatra Yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF18181B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Mark your planned visits as completed after Darshan to save them in history.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
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
        return _buildPlanCard(context, plan, isDark, isHistory: true);
      },
    );
  }

  Widget _buildPlanCard(BuildContext context, YatraPlan plan, bool isDark, {bool isHistory = false}) {
    final dateStr = '${plan.plannedDate.day}/${plan.plannedDate.month}/${plan.plannedDate.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141417) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF27272A) : const Color(0xFFE5E7EB),
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
                  color: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isHistory ? Icons.check_circle_outline : Icons.temple_hindu_outlined,
                  size: 20,
                  color: isDark ? Colors.white : const Color(0xFF18181B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.templeName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF18181B),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.event_outlined, size: 13, color: Color(0xFF71717A)),
                        const SizedBox(width: 4),
                        Text(
                          'Visit Date: $dateStr',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF71717A), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Mark Completed Checkbox
              IconButton(
                tooltip: isHistory ? 'Mark as Pending' : 'Mark Completed',
                icon: Icon(
                  isHistory ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isHistory ? (isDark ? Colors.white : const Color(0xFF18181B)) : const Color(0xFFA1A1AA),
                ),
                onPressed: () {
                  ref.read(yatraPlannerProvider.notifier).toggleCompleted(plan.id);
                },
              ),
              // Delete Button
              IconButton(
                tooltip: 'Delete Plan',
                icon: const Icon(Icons.delete_outline, color: Color(0xFF71717A), size: 20),
                onPressed: () {
                  ref.read(yatraPlannerProvider.notifier).removePlan(plan.id);
                },
              ),
            ],
          ),

          // Simple Clean Subtitle for Active Alerts
          if (!isHistory && (plan.oneDayBeforeReminder || plan.reminderOption != 'none')) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.notifications_active_outlined, size: 13, color: Color(0xFF71717A)),
                const SizedBox(width: 4),
                Text(
                  'Alerts Active: ${plan.oneDayBeforeReminder ? "1-Day Evening" : ""}${plan.reminderOption != "none" ? " • ${plan.reminderOption == "1_hour" ? "1 Hr" : "30m"} Pre-Darshan" : ""}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF71717A), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
