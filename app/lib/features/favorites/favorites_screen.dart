import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/temple_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final allTemplesAsync = ref.watch(allTemplesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Favorites',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: favoriteIds.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).colorScheme.outline),
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Saved Shrines Yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on any temple card to save it here for quick access.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(160, 48),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.go('/');
                      },
                      child: Text('Explore Shrines', style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 300.ms)
          : allTemplesAsync.when(
              data: (temples) {
                final favTemples = temples.where((t) => favoriteIds.contains(t.id)).toList();
                if (favTemples.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'Loading saved shrines...',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: favTemples.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final t = favTemples[index];
                    return TempleCard(
                      temple: t,
                      showImage: true,
                      imageHeight: 110,
                      heroTag: 'fav_${t.id}',
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.push('/temple/${t.id}');
                      },
                    );
                  },
                ).animate().fadeIn(duration: 250.ms);
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    LoadingSkeleton(height: 140),
                    SizedBox(height: 12),
                    LoadingSkeleton(height: 140),
                  ],
                ),
              ),
              error: (err, _) => ErrorView(
                message: 'Failed to load saved shrines',
                onRetry: () => ref.refresh(allTemplesProvider),
              ),
            ),
    );
  }
}

