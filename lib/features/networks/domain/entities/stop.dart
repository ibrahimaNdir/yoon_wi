import 'package:equatable/equatable.dart';

class Stop extends Equatable {
  const Stop(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}
