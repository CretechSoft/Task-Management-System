class AppException implements Exception {
  final String message;
  final int? code;
  final dynamic details;

  AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
    super.details,
  });
}

class NetworkException extends AppException {
  NetworkException({
    super.message = 'Network error. Please check your connection.',
  });
}

class CacheException extends AppException {
  CacheException({
    super.message = 'Local storage error.',
  });
}

class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.details,
  });
}

class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'Unauthorized. Please login again.',
  });
}

class NotFoundException extends AppException {
  NotFoundException({
    super.message = 'Resource not found.',
  });
}

class PermissionException extends AppException {
  PermissionException({
    super.message = 'You do not have permission to perform this action.',
  });
}
