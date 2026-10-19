class LocalException implements Exception {
  const LocalException([this.message = 'Erreur de données locales.']);
  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'Pas de connexion.']);
  final String message;
}

class ServerException implements Exception {
  const ServerException([this.message = 'Erreur du serveur.']);
  final String message;
}
