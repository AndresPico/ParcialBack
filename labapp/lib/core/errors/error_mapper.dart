import 'package:dio/dio.dart';

import 'app_exception.dart';

AppException mapDioException(Object error) {
  if (error is AppException) return error;
  if (error is DioException) {
    final status = error.response?.statusCode;
    final payload = error.response?.data;
    final message = payload is Map<String, dynamic>
        ? (payload['message'] ?? payload['error'] ?? error.message).toString()
        : error.message ?? 'No fue posible conectar con el servidor.';
    if (status == 401 || status == 403) return UnauthorizedException(message);
    if (status != null && status >= 400 && status < 500) {
      return ValidationException(message, statusCode: status);
    }
    return NetworkException(message, statusCode: status);
  }
  return const UnknownAppException();
}
