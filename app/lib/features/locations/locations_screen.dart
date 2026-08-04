import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';

class LocationsScreen extends ConsumerWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationsAsync = ref.watch(locationsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Holy Dham Locations'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      ),
      body: locationsAsync.when(
        data: (locations) {
          if (locations.isEmpty) {
            return const Center(child: Text('No locations found'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: locations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final loc = locations[index];
              final hasDistrict = loc.district?.isNotEmpty ?? false;
              final locationSubtitle = hasDistrict
                  ? '${loc.district}, ${loc.state ?? "Uttar Pradesh"}'
                  : 'Mathura District';

              return Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF141417) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? const Color(0x20000000) : const Color(0x06000000),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: () {
                      ref.read(searchQueryProvider.notifier).state = SearchQuery(
                        locationId: loc.id,
                      );
                      context.push('/search');
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 26,
                              color: isDark ? Colors.white : const Color(0xFF18181B),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF18181B),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  locationSubtitle,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF71717A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 20, color: Color(0xFFA1A1AA)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ).animate().fadeIn(duration: 300.ms);
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              LoadingSkeleton(height: 80),
              SizedBox(height: 12),
              LoadingSkeleton(height: 80),
            ],
          ),
        ),
        error: (err, _) => ErrorView(
          message: 'Failed to load locations',
          onRetry: () => ref.refresh(locationsProvider),
        ),
      ),
    );
  }
}
