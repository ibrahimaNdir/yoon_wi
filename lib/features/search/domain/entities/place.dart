import 'package:equatable/equatable.dart';

class Place extends Equatable {
  const Place({
    required this.id,
    required this.name,
    required this.zone,
    required this.isPopular,
    this.aliases = const [],
  });

  final String id;
  final String name;
  final String zone;
  final bool isPopular;
  final List<String> aliases;

  @override
  List<Object> get props => [id, name, zone, isPopular, aliases];
}
