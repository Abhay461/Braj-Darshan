import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/temple_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultsAsync = ref.watch(searchTemplesProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search temples, keywords, tags...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: (val) {
            ref.read(searchQueryProvider.notifier).state = SearchQuery(text: val);
          },
        ),
      ),
      body: searchResultsAsync.when(
        data: (temples) {
          if (temples.isEmpty) {
            return const Center(
              child: Text(
                'No shrines found matching your search',
                style: TextStyle(color: Color(0xFF71717A)),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: temples.length,
            itemBuilder: (context, index) {
              final temple = temples[index];
              return TempleCard(
                temple: temple,
                onTap: () => context.push('/temple/${temple.id}'),
              );
            },
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              LoadingSkeleton(height: 160),
              SizedBox(height: 16),
              LoadingSkeleton(height: 160),
            ],
          ),
        ),
        error: (err, _) => ErrorView(
          message: 'Search failed',
          onRetry: () => ref.refresh(searchTemplesProvider),
        ),
      ),
    );
  }
}
