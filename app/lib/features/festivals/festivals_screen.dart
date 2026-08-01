import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';

class FestivalsScreen extends ConsumerWidget {
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalsAsync = ref.watch(festivalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Braj Utsavs & Festivals')),
      body: festivalsAsync.when(
        data: (festivals) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: festivals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final fest = festivals[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fest.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      fest.description ?? 'Annual cultural celebration across Braj Mandal',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: LoadingSkeleton(height: 100),
        ),
        error: (_, __) => const Center(child: Text('Failed to load festivals')),
      ),
    );
  }
}
