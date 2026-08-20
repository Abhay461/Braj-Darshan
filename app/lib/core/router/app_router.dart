import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/temple/temple_detail_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/locations/locations_screen.dart';
import '../../features/festivals/festivals_screen.dart';
import '../../features/map/interactive_map_screen.dart';
import '../../features/planner/yatra_planner_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/about/about_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page Not Found')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.explore_off_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Shrine / Page Not Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'The requested link (${state.uri}) does not exist.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.home),
            label: const Text('Return Home'),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/temple/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TempleDetailScreen(templeId: id);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/locations',
      builder: (context, state) => const LocationsScreen(),
    ),
    GoRoute(
      path: '/festivals',
      builder: (context, state) => const FestivalsScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const InteractiveMapScreen(),
    ),
    GoRoute(
      path: '/yatra-planner',
      builder: (context, state) => const YatraPlannerScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);

