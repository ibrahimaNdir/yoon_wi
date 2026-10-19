import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class LocalFailure extends Failure {
  const LocalFailure([super.message = 'Données locales indisponibles.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Pas de connexion.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erreur du serveur.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Élément introuvable.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Autorisation refusée.']);
}
