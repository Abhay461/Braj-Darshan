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

final appRouter = GoRouter(
  initialLocation: '/',
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
  ],
);
