import 'package:equatable/equatable.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class SavedTrip extends Equatable {
  const SavedTrip({required this.from, required this.to});

  final Place from;
  final Place to;

  String get id => '${from.id}>${to.id}';

  @override
  List<Object> get props => [from, to];
}
