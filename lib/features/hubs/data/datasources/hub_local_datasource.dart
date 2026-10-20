import 'package:yoon_wi/core/constants/asset_paths.dart';
import 'package:yoon_wi/core/data/local_json_loader.dart';
import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/hubs/data/models/hub_model.dart';

abstract class HubLocalDataSource {
  Future<List<HubModel>> getHubs();
}

class HubLocalDataSourceImpl implements HubLocalDataSource {
  HubLocalDataSourceImpl(this._loader);
  final LocalJsonLoader _loader;

  @override
  Future<List<HubModel>> getHubs() async {
    final json = await _loader.loadMap(AssetPaths.hubs);
    return JsonParsers.objects(json, 'hubs').map(HubModel.fromJson).toList();
  }
}
