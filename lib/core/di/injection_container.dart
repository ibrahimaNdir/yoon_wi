import 'package:get_it/get_it.dart';
import 'package:yoon_wi/core/data/local_json_loader.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<LocalJsonLoader>(() => LocalJsonLoader());
  // Les dépendances de chaque fonctionnalité seront ajoutées ici.
}
