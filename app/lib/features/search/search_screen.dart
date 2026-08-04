import 'dart:async';
import 'package:flutter/material.dart';
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
    _searchController.text = suggestion;
    ref.read(searchQueryProvider.notifier).state = SearchQuery(
      text: suggestion,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchAsync = ref.watch(searchTemplesProvider);
    final queryText = ref.watch(searchQueryProvider).text;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF18181B),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _popularSuggestions
                    .map((sug) => ActionChip(
                          label: Text(sug),
                          backgroundColor: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF4F4F5),
                          side: BorderSide(color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7)),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF18181B),
                          ),
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
                          Icon(Icons.search_off_outlined, size: 48, color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A)),
                          const SizedBox(height: 12),
                          Text(
                            'No shrines matching "$queryText"',
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: temples
                          .map((t) => TempleCard(
                                temple: t,
                                showImage: false,
                                heroTag: 'search_${t.id}',
                                onTap: () => context.push('/temple/${t.id}'),
                              ))
                          .toList(),
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
    );
  }
}
