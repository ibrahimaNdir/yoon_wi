import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoon_wi/core/data/local_json_loader.dart';
import 'package:yoon_wi/core/services/permission_service.dart';
import 'package:yoon_wi/features/networks/data/datasources/network_local_datasource.dart';
import 'package:yoon_wi/features/networks/data/repositories/network_repository_impl.dart';
import 'package:yoon_wi/features/networks/domain/repositories/network_repository.dart';
import 'package:yoon_wi/features/networks/domain/usecases/get_lines.dart';
import 'package:yoon_wi/features/networks/domain/usecases/get_stops.dart';
import 'package:yoon_wi/features/networks/domain/usecases/get_transport_types.dart';
import 'package:yoon_wi/features/networks/presentation/bloc/lines_cubit.dart';
import 'package:yoon_wi/features/networks/presentation/bloc/stops_cubit.dart';
import 'package:yoon_wi/features/networks/presentation/bloc/types_cubit.dart';
import 'package:yoon_wi/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:yoon_wi/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:yoon_wi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:yoon_wi/features/onboarding/domain/usecases/get_onboarding_seen.dart';
import 'package:yoon_wi/features/onboarding/domain/usecases/mark_onboarding_seen.dart';
import 'package:yoon_wi/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:yoon_wi/features/hubs/data/datasources/hub_local_datasource.dart';
import 'package:yoon_wi/features/hubs/data/repositories/hub_repository_impl.dart';
import 'package:yoon_wi/features/hubs/domain/repositories/hub_repository.dart';
import 'package:yoon_wi/features/hubs/domain/usecases/get_hub.dart';
import 'package:yoon_wi/features/hubs/domain/usecases/get_hubs.dart';
import 'package:yoon_wi/features/hubs/presentation/bloc/hub_cubit.dart';
import 'package:yoon_wi/features/hubs/presentation/bloc/hubs_cubit.dart';
import 'package:yoon_wi/features/search/data/datasources/place_local_datasource.dart';
import 'package:yoon_wi/features/search/data/repositories/place_repository_impl.dart';
import 'package:yoon_wi/features/search/domain/repositories/place_repository.dart';
import 'package:yoon_wi/features/search/domain/usecases/search_places.dart';
import 'package:yoon_wi/features/search/presentation/bloc/place_search_cubit.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/features/itinerary/data/repositories/itinerary_repository_impl.dart';
import 'package:yoon_wi/features/itinerary/domain/engine/route_planner.dart';
import 'package:yoon_wi/features/itinerary/domain/repositories/itinerary_repository.dart';
import 'package:yoon_wi/features/itinerary/domain/usecases/find_itineraries.dart';
import 'package:yoon_wi/features/itinerary/presentation/bloc/itinerary_cubit.dart';
import 'package:yoon_wi/core/services/share_service.dart';
import 'package:yoon_wi/features/itinerary/domain/usecases/share_itinerary.dart';
import 'package:yoon_wi/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:yoon_wi/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:yoon_wi/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:yoon_wi/features/favorites/domain/usecases/add_favorite_place.dart';
import 'package:yoon_wi/features/favorites/domain/usecases/get_favorites.dart';
import 'package:yoon_wi/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:yoon_wi/features/favorites/domain/usecases/save_trip.dart';
import 'package:yoon_wi/features/favorites/presentation/bloc/favorites_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<LocalJsonLoader>(() => LocalJsonLoader());
  sl.registerLazySingleton<PermissionService>(() => PermissionService());

  // Onboarding
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetOnboardingSeen(sl()));
  sl.registerLazySingleton(() => MarkOnboardingSeen(sl()));
  sl.registerFactory(() => OnboardingCubit(markSeen: sl(), permissions: sl()));

  // Réseaux
  sl.registerLazySingleton<NetworkLocalDataSource>(
    () => NetworkLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NetworkRepository>(
    () => NetworkRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetTransportTypes(sl()));
  sl.registerLazySingleton(() => GetLines(sl()));
  sl.registerLazySingleton(() => GetStops(sl()));
  sl.registerFactory(() => TypesCubit(sl()));
  sl.registerFactory(() => LinesCubit(sl()));
  sl.registerFactory(() => StopsCubit(sl()));

  // Hubs
  sl.registerLazySingleton<HubLocalDataSource>(
    () => HubLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<HubRepository>(() => HubRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetHubs(sl()));
  sl.registerLazySingleton(() => GetHub(sl()));
  sl.registerFactory(() => HubsCubit(sl()));
  sl.registerFactory(() => HubCubit(sl()));

  // Recherche
  sl.registerLazySingleton<PlaceLocalDataSource>(
    () => PlaceLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PlaceRepository>(() => PlaceRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SearchPlaces(sl()));
  sl.registerFactory(() => PlaceSearchCubit(sl()));
  // Un seul formulaire partagé par l'écran et les pages de choix
  sl.registerLazySingleton(() => SearchFormCubit());

  // Itinéraire
  sl.registerLazySingleton<RoutePlanner>(() => LocalRoutePlanner());
  sl.registerLazySingleton<ItineraryRepository>(
    () => ItineraryRepositoryImpl(networks: sl(), hubs: sl(), planner: sl()),
  );
  sl.registerLazySingleton(() => FindItineraries(sl()));
  sl.registerFactory(() => ItineraryCubit(sl()));
  sl.registerLazySingleton<ShareService>(() => SharePlusShareService());
  sl.registerLazySingleton(() => ShareItinerary(sl()));

  // Favoris
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddFavoritePlace(sl()));
  sl.registerLazySingleton(() => RemoveFavoritePlace(sl()));
  sl.registerLazySingleton(() => SaveTrip(sl()));
  sl.registerLazySingleton(() => RemoveSavedTrip(sl()));
  // Un seul cubit partagé, chargé à sa première utilisation
  sl.registerLazySingleton(
    () => FavoritesCubit(
      getFavorites: sl(),
      addPlace: sl(),
      removePlace: sl(),
      saveTrip: sl(),
      removeTrip: sl(),
    )..load(),
  );
}
