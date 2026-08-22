import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/providers.dart';

class QuickActionsSection extends ConsumerWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final actions = [
      _QuickAction(
        label: 'Favorites',
        icon: Icons.favorite_outline,
        color: Colors.red.shade400,
        onTap: () => context.push('/favorites'),
      ),
      _QuickAction(
        label: 'Festivals',
        icon: Icons.celebration_outlined,
        color: Colors.purple.shade400,
        onTap: () => context.push('/festivals'),
      ),
      _QuickAction(
        label: 'Map',
        icon: Icons.map_outlined,
        color: Colors.blue.shade400,
        onTap: () => context.push('/map'),
      ),
      _QuickAction(
        label: 'Yatra Planner',
        icon: Icons.route_outlined,
        color: Colors.green.shade400,
        onTap: () => context.push('/yatra-planner'),
      ),
      _QuickAction(
        label: 'Categories',
        icon: Icons.category_outlined,
        color: Colors.orange.shade400,
        onTap: () => context.push('/categories'),
      ),
      _QuickAction(
        label: 'Locations',
        icon: Icons.location_on_outlined,
        color: Colors.teal.shade400,
        onTap: () => context.push('/locations'),
      ),
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Icon(
                  Icons.flash_on_outlined,
                  size: 18,
                  color: isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron,
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          
          // Actions Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _QuickActionTile(
                action: action,
                isDark: isDark,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  
  _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _QuickActionTile extends StatelessWidget {
  final _QuickAction action;
  final bool isDark;
  
  const _QuickActionTile({
    required this.action,
    required this.isDark,
  });
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: action.label,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  action.color.withValues(alpha: isDark ? 0.18 : 0.1),
                  action.color.withValues(alpha: isDark ? 0.1 : 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              border: Border.all(
                color: action.color.withValues(alpha: isDark ? 0.3 : 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: isDark ? 0.25 : 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    action.icon,
                    color: action.color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  action.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
