import 'package:yoon_wi/core/constants/asset_paths.dart';
import 'package:yoon_wi/core/data/local_json_loader.dart';
import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/networks/data/models/transport_type_model.dart';

abstract class NetworkLocalDataSource {
  Future<List<TransportTypeModel>> getNetworks();
}

class NetworkLocalDataSourceImpl implements NetworkLocalDataSource {
  NetworkLocalDataSourceImpl(this._loader);
  final LocalJsonLoader _loader;

  @override
  Future<List<TransportTypeModel>> getNetworks() async {
    final json = await _loader.loadMap(AssetPaths.reseaux);
    return JsonParsers.objects(
      json,
      'reseaux',
    ).map(TransportTypeModel.fromJson).toList();
  }
}
