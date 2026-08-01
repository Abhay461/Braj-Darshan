import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Temple Categories')),
      body: categoriesAsync.when(
        data: (categories) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final cat = categories[index];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF4F4F5),
                  child: Icon(Icons.temple_hindu_outlined, color: Color(0xFF18181B)),
                ),
                title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(cat.description ?? 'Sacred shrine classification'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(searchQueryProvider.notifier).state = SearchQuery(categoryId: cat.id);
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
        error: (_, __) => const Center(child: Text('Failed to load categories')),
      ),
    );
  }
}
