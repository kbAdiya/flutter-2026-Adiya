sealed class ApiException implements Exception {
  const ApiException();
}

// Нет соединения или сервер не ответил вовремя
class NoConnectionException extends ApiException {
  const NoConnectionException();
}

// Ошибка сервера: 500, 502, 503 и другие 5xx
class ServerException extends ApiException {
  const ServerException(this.status);

  final int status;
}

// Пользователь или ресурс не найден: 404
class NotFoundException extends ApiException {
  const NotFoundException();
}

// Нет авторизации: 401
class UnauthorizedException extends ApiException {
  const UnauthorizedException();
}

// Сервер вернул JSON, который мы не смогли обработать
class BadResponseException extends ApiException {
  const BadResponseException([this.detail]);

  final String? detail;
}
