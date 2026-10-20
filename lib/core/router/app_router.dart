import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/router/app_shell.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/features/favorites/presentation/pages/favorites_page.dart';
import 'package:yoon_wi/features/networks/presentation/pages/types_page.dart';
import 'package:yoon_wi/features/onboarding/presentation/pages/permissions_page.dart';
import 'package:yoon_wi/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:yoon_wi/features/search/presentation/pages/search_page.dart';
import 'package:yoon_wi/features/settings/presentation/pages/profile_page.dart';

GoRouter createAppRouter({bool showOnboarding = false}) {
  return GoRouter(
    initialLocation: showOnboarding ? RouteNames.welcome : RouteNames.search,
    routes: [
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: RouteNames.permissions,
        builder: (context, state) => const PermissionsPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.search,
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.networks,
                builder: (context, state) => const TypesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.favorites,
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
