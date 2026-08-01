import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/temple_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/ad_banner_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredTemplesProvider);
    final popularAsync = ref.watch(popularTemplesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Braj Darshan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push('/map'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(featuredTemplesProvider);
          ref.refresh(popularTemplesProvider);
          ref.refresh(categoriesProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar Box
              InkWell(
                onTap: () => context.push('/search'),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE4E4E7)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Color(0xFF71717A)),
                      SizedBox(width: 12),
                      Text(
                        'Search temples, locations, keywords...',
                        style: TextStyle(color: Color(0xFF71717A), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Categories Row
              categoriesAsync.when(
                data: (categories) => SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return ActionChip(
                        label: Text(cat.name),
                        onPressed: () => context.push('/categories'),
                      );
                    },
                  ),
                ),
                loading: () => const LoadingSkeleton(height: 40),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),

              // Featured Temples Section
              const Text(
                'Featured Shrines',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              featuredAsync.when(
                data: (temples) => Column(
                  children: temples
                      .map((t) => TempleCard(
                            temple: t,
                            onTap: () => context.push('/temple/${t.id}'),
                          ))
                      .toList(),
                ).animate().fadeIn(duration: 300.ms),
                loading: () => const Column(
                  children: [
                    LoadingSkeleton(height: 240),
                    SizedBox(height: 16),
                    LoadingSkeleton(height: 240),
                  ],
                ),
                error: (err, _) => ErrorView(
                  message: 'Failed to load featured shrines',
                  onRetry: () => ref.refresh(featuredTemplesProvider),
                ),
              ),

              const SizedBox(height: 24),

              // Popular Shrines Section
              const Text(
                'Popular Shrines',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              popularAsync.when(
                data: (temples) => Column(
                  children: temples
                      .map((t) => TempleCard(
                            temple: t,
                            onTap: () => context.push('/temple/${t.id}'),
                          ))
                      .toList(),
                ),
                loading: () => const LoadingSkeleton(height: 200),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),
              const AdBannerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
