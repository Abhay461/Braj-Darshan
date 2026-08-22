import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/providers/providers.dart';

class EmergencyQuickAction extends ConsumerWidget {
  const EmergencyQuickAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(emergencyContactsProvider);
    
    return contactsAsync.when(
      data: (contacts) {
        if (contacts.isEmpty) return const SizedBox.shrink();
        return _EmergencyQuickActionContent(contacts: contacts);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _EmergencyQuickActionContent extends ConsumerStatefulWidget {
  final List<EmergencyContact> contacts;
  
  const _EmergencyQuickActionContent({required this.contacts});
  
  @override
  ConsumerState<_EmergencyQuickActionContent> createState() => _EmergencyQuickActionContentState();
}

class _EmergencyQuickActionContentState extends ConsumerState<_EmergencyQuickActionContent> {
  bool _showSheet = false;
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Group contacts by category
    final touristPolice = widget.contacts.where((c) => c.category == 'tourist_police' && c.isActive).toList();
    final hospitals = widget.contacts.where((c) => c.category == 'hospital' && c.isActive).toList();
    final ambulances = widget.contacts.where((c) => c.category == 'ambulance' && c.isActive).toList();
    final others = widget.contacts.where((c) => 
      !['tourist_police', 'hospital', 'ambulance'].contains(c.category) && c.isActive).toList();
    
    final quickActions = <_QuickActionItem>[
      if (touristPolice.isNotEmpty)
        _QuickActionItem(
          label: 'Tourist Police',
          icon: Icons.local_police_outlined,
          color: Colors.blue.shade700,
          contacts: touristPolice,
        ),
      if (hospitals.isNotEmpty)
        _QuickActionItem(
          label: 'Hospitals',
          icon: Icons.local_hospital_outlined,
          color: Colors.red.shade700,
          contacts: hospitals,
        ),
      if (ambulances.isNotEmpty)
        _QuickActionItem(
          label: 'Ambulance',
          icon: Icons.emergency_outlined,
          color: Colors.orange.shade700,
          contacts: ambulances,
        ),
    ];
    
    if (quickActions.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.security_outlined,
                  size: 18,
                  color: isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron,
                ),
                const SizedBox(width: 8),
                Text(
                  'Emergency & Yatri Help',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          
          // Quick Action Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: quickActions.map((action) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _QuickActionButton(
                    action: action,
                    onTap: () => _showContactsSheet(context, action),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Show All Button (if more contacts exist)
          if (others.isNotEmpty) ...[
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () => _showAllContactsSheet(context),
                icon: Icon(
                  Icons.expand_more,
                  size: 18,
                  color: isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron,
                ),
label: Text(
                  'View All Helplines (${others.length} more)',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  void _showContactsSheet(BuildContext context, _QuickActionItem action) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ContactsBottomSheet(
        title: action.label,
        icon: action.icon,
        color: action.color,
        contacts: action.contacts,
      ),
    );
  }
  
  void _showAllContactsSheet(BuildContext context) {
    final allContacts = widget.contacts.where((c) => c.isActive).toList();
    allContacts.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ContactsBottomSheet(
        title: 'All Emergency Contacts',
        icon: Icons.help_outline,
        color: AppTheme.primarySaffron,
        contacts: allContacts,
      ),
    );
  }
}

class _QuickActionItem {
  final String label;
  final IconData icon;
  final Color color;
  final List<EmergencyContact> contacts;
  
  _QuickActionItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.contacts,
  });
}

class _QuickActionButton extends StatelessWidget {
  final _QuickActionItem action;
  final VoidCallback onTap;
  
  const _QuickActionButton({
    required this.action,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
return Semantics(
      label: 'Emergency: ${action.label}. Tap to view contacts.',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  action.color.withValues(alpha: isDark ? 0.2 : 0.12),
                  action.color.withValues(alpha: isDark ? 0.1 : 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: action.color.withValues(alpha: isDark ? 0.3 : 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: isDark ? 0.25 : 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    action.icon,
                    color: action.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  action.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: action.color,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: action.color.withValues(alpha: 0.6),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactsBottomSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<EmergencyContact> contacts;
  
  const _ContactsBottomSheet({
    required this.title,
    required this.icon,
    required this.color,
    required this.contacts,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.creamWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusLarge)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
Text(
                          '${contacts.length} contact${contacts.length > 1 ? "s" : ""} available',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Contacts List
            Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: contacts.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 56,
                  endIndent: 16,
                  color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                ),
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return _ContactListTile(
                    contact: contact,
                    accentColor: color,
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ContactListTile extends StatelessWidget {
  final EmergencyContact contact;
  final Color accentColor;
  
  const _ContactListTile({
    required this.contact,
    required this.accentColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: isDark ? 0.18 : 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          contact.categoryIcon,
          color: accentColor,
          size: 22,
        ),
      ),
      title: Text(
        contact.name,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (contact.description != null && contact.description!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              contact.description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (contact.location != null && contact.location!.name != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 11,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  contact.location!.name!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          contact.phone,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
      ),
      onTap: () => _confirmCall(context, contact),
    );
  }
  
  void _confirmCall(BuildContext context, EmergencyContact contact) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(contact.categoryIcon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 10),
Expanded(
              child: Text(
                'Call ${contact.name}?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to call this number?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                    : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: accentColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    contact.phone,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            if (contact.isVerified) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.verified,
                    size: 14,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Verified number',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _makeCall(contact.phone);
            },
            icon: const Icon(Icons.phone, size: 18),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
