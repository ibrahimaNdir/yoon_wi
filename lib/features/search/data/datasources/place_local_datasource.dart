import 'package:yoon_wi/core/constants/asset_paths.dart';
import 'package:yoon_wi/core/data/local_json_loader.dart';
import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/search/data/models/place_model.dart';

abstract class PlaceLocalDataSource {
  Future<List<PlaceModel>> getPlaces();
}

class PlaceLocalDataSourceImpl implements PlaceLocalDataSource {
  PlaceLocalDataSourceImpl(this._loader);
  final LocalJsonLoader _loader;

  @override
  Future<List<PlaceModel>> getPlaces() async {
    final json = await _loader.loadMap(AssetPaths.places);
    return JsonParsers.objects(json, 'lieux').map(PlaceModel.fromJson).toList();
  }
}
