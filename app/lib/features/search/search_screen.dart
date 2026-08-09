import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/temple_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  final List<String> _popularSuggestions = [
    'Bankey Bihari',
    'Prem Mandir',
    'ISKCON',
    'Radha Raman',
    'Nidhivan',
    'Goverdhan Hill',
  ];

  @override
  void initState() {
    super.initState();
    final currentQuery = ref.read(searchQueryProvider).text;
    _searchController.text = currentQuery;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      ref.read(searchQueryProvider.notifier).state = SearchQuery(
        text: value.trim(),
        categoryId: ref.read(searchQueryProvider).categoryId,
        locationId: ref.read(searchQueryProvider).locationId,
      );
    });
  }

  void _selectSuggestion(String suggestion) {
    HapticFeedback.selectionClick();
    _searchController.text = suggestion;
    ref.read(searchQueryProvider.notifier).state = SearchQuery(
      text: suggestion,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchTemplesProvider);
    final queryText = ref.watch(searchQueryProvider).text;

    return SafeArea(
      top: true,
      child: Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search temples, dham, keywords...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _searchController.clear();
                        _onSearchChanged('');
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular Searches Chips
            if (queryText.isEmpty) ...[
              Text(
                'Popular Searches',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: _popularSuggestions
                    .map((sug) => ActionChip(
                          label: Text(sug),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          side: BorderSide(color: Theme.of(context).colorScheme.outline),
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          onPressed: () => _selectSuggestion(sug),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Search Results Section
            searchAsync.when(
              data: (temples) {
                if (queryText.isNotEmpty && temples.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No shrines matching "$queryText"',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (queryText.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${temples.length} Results Found',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: temples.length,
                      itemBuilder: (context, index) {
                        final t = temples[index];
                        return TempleCard(
                          temple: t,
                          showImage: false,
                          heroTag: 'search_${t.id}',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.push('/temple/${t.id}');
                          },
                        );
                      },
                    ).animate().fadeIn(duration: 250.ms),
                  ],
                );
              },
              loading: () => const Column(
                children: [
                  LoadingSkeleton(height: 55),
                  SizedBox(height: 8),
                  LoadingSkeleton(height: 55),
                  SizedBox(height: 8),
                  LoadingSkeleton(height: 55),
                ],
              ),
              error: (err, _) => ErrorView(
                message: 'Failed to search shrines',
                onRetry: () => ref.refresh(searchTemplesProvider),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}

