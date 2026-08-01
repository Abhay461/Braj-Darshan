import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/temple_card.dart';
import '../../shared/widgets/loading_skeleton.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final popularAsync = ref.watch(popularTemplesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Offline Saved Shrines')),
      body: favoriteIds.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 48, color: Color(0xFF71717A)),
                    SizedBox(height: 16),
                    Text(
                      'No saved shrines yet',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on any temple to save it for offline viewing.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
                    ),
                  ],
                ),
              ),
            )
          : popularAsync.when(
              data: (temples) {
                final favTemples = temples.where((t) => favoriteIds.contains(t.id)).toList();
                if (favTemples.isEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoriteIds.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text('Shrine ID: ${favoriteIds[index]}'),
                      subtitle: const Text('Saved offline'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/temple/${favoriteIds[index]}'),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favTemples.length,
                  itemBuilder: (context, index) {
                    final temple = favTemples[index];
                    return TempleCard(
                      temple: temple,
                      onTap: () => context.push('/temple/${temple.id}'),
                    );
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: LoadingSkeleton(height: 160),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
    );
  }
}
