import 'package:flutter/material.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteIds = ref.watch(favoritesProvider);
    final allTemplesAsync = ref.watch(allTemplesProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Saved Favorites'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
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
                        color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF4F4F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 48,
                        color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Saved Shrines Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF18181B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on any temple card to save it here for quick access.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : const Color(0xFF18181B),
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => context.go('/'),
                      child: const Text('Explore Shrines', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 300.ms)
          : allTemplesAsync.when(
              data: (temples) {
                final favTemples = temples.where((t) => favoriteIds.contains(t.id)).toList();
                if (favTemples.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('Loading saved shrines...'),
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: favTemples
                        .map((t) => TempleCard(
                              temple: t,
                              showImage: true,
                              imageHeight: 110,
                              heroTag: 'fav_${t.id}',
                              onTap: () => context.push('/temple/${t.id}'),
                            ))
                        .toList(),
                  ).animate().fadeIn(duration: 250.ms),
                );
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
