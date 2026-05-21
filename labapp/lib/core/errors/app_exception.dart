sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Tu sesión expiró.']);
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.statusCode});
}

class UnknownAppException extends AppException {
  const UnknownAppException([super.message = 'Ocurrió un error inesperado.']);
}
