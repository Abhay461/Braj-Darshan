import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shrine Categories',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: Text(
                'No categories found',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final hasDescription = cat.description?.isNotEmpty ?? false;
                  final displayDesc = hasDescription ? cat.description! : 'Explore Shrines';

                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ref.read(searchQueryProvider.notifier).state = SearchQuery(
                            categoryId: cat.id,
                          );
                          context.push('/search');
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity( 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.temple_hindu_outlined,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat.name,
                                    style: Theme.of(context).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    displayDesc,
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).animate().fadeIn(duration: 300.ms);
            },
          );
        },
        loading: () => LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);
            return GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: const [
                LoadingSkeleton(height: 100),
                LoadingSkeleton(height: 100),
                LoadingSkeleton(height: 100),
                LoadingSkeleton(height: 100),
              ],
            );
          },
        ),
        error: (err, _) => ErrorView(
          message: 'Failed to load categories',
          onRetry: () => ref.refresh(categoriesProvider),
        ),
      ),
    );
  }
}

