import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';

class LocationsScreen extends ConsumerWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsAsync = ref.watch(locationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sacred Locations')),
      body: locationsAsync.when(
        data: (locations) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: locations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final loc = locations[index];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF4F4F5),
                  child: Icon(Icons.location_on_outlined, color: Color(0xFF18181B)),
                ),
                title: Text(loc.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text('${loc.district ?? 'Mathura'}, ${loc.state ?? 'Uttar Pradesh'}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(searchQueryProvider.notifier).state = SearchQuery(locationId: loc.id);
                  context.push('/search');
                },
              ),
            );
          },
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              LoadingSkeleton(height: 70),
              SizedBox(height: 12),
              LoadingSkeleton(height: 70),
            ],
          ),
        ),
        error: (_, __) => const Center(child: Text('Failed to load locations')),
      ),
    );
  }
}
