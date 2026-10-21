import 'package:flutter/material.dart';
import 'package:yoon_wi/features/hubs/presentation/pages/hub_page.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/router/app_shell.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/features/favorites/presentation/pages/favorites_page.dart';
import 'package:yoon_wi/features/networks/presentation/pages/lines_page.dart';
import 'package:yoon_wi/features/networks/presentation/pages/stops_page.dart';
import 'package:yoon_wi/features/networks/presentation/pages/types_page.dart';
import 'package:yoon_wi/features/onboarding/presentation/pages/permissions_page.dart';
import 'package:yoon_wi/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:yoon_wi/features/search/presentation/pages/search_page.dart';
import 'package:yoon_wi/features/settings/presentation/pages/profile_page.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_state.dart';
import 'package:yoon_wi/features/search/presentation/pages/place_picker_page.dart';
import 'package:yoon_wi/features/search/presentation/pages/preferences_page.dart';
import 'package:yoon_wi/features/search/presentation/pages/time_picker_page.dart';
import 'package:yoon_wi/features/itinerary/presentation/pages/itinerary_results_page.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/presentation/pages/roadmap_page.dart';

GoRouter createAppRouter({bool showOnboarding = false}) {
  final rootKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
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
      GoRoute(
        path: '${RouteNames.hubs}/:id',
        builder:
            (context, state) => HubPage(hubId: state.pathParameters['id']!),
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
                routes: [
                  // Ces pages s'affichent par-dessus la barre du bas.
                  GoRoute(
                    path: 'place',
                    parentNavigatorKey: rootKey,
                    builder:
                        (context, state) => PlacePickerPage(
                          field:
                              state.uri.queryParameters['field'] == 'to'
                                  ? SearchField.to
                                  : SearchField.from,
                        ),
                  ),
                  GoRoute(
                    path: 'time',
                    parentNavigatorKey: rootKey,
                    builder: (context, state) => const TimePickerPage(),
                  ),
                  GoRoute(
                    path: 'preferences',
                    parentNavigatorKey: rootKey,
                    builder: (context, state) => const PreferencesPage(),
                  ),
                  GoRoute(
                    path: 'results',
                    parentNavigatorKey: rootKey,
                    builder: (context, state) => const ItineraryResultsPage(),
                  ),
                  GoRoute(
                    path: 'roadmap',
                    parentNavigatorKey: rootKey,
                    builder: (context, state) {
                      final extra = state.extra;
                      return RoadmapPage(
                        itinerary: extra is Itinerary ? extra : null,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.networks,
                builder: (context, state) => const TypesPage(),
                routes: [
                  // Lignes et arrêts s'affichent par-dessus la barre du bas.
                  GoRoute(
                    path: ':type',
                    parentNavigatorKey: rootKey,
                    builder:
                        (context, state) =>
                            LinesPage(typeName: state.pathParameters['type']!),
                    routes: [
                      GoRoute(
                        path: ':line',
                        parentNavigatorKey: rootKey,
                        builder:
                            (context, state) => StopsPage(
                              typeName: state.pathParameters['type']!,
                              lineCode: state.pathParameters['line']!,
                            ),
                      ),
                    ],
                  ),
                ],
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
