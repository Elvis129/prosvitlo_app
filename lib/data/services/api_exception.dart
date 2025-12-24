/// Types of API exceptions for categorizing errors
enum ApiExceptionType {
  /// Request timeout (connection, send, or receive timeout)
  timeout,

  /// No internet connection or server unreachable
  noInternet,

  /// Server returned an error response (4xx, 5xx)
  serverError,

  /// Failed to parse response data
  parseError,

  /// Request was cancelled
  cancelled,

  /// Unknown or unhandled error
  unknown,
}

/// Custom exception for API errors with type categorization and user-friendly messages
class ApiException implements Exception {
  final String message;
  final ApiExceptionType type;
  final int? statusCode;

  ApiException({required this.message, required this.type, this.statusCode});

  /// Create a timeout exception
  factory ApiException.timeout([String? customMessage]) => ApiException(
    message:
        customMessage ??
        'Час очікування відповіді сервера вичерпано. Перевірте інтернет-з\'єднання.',
    type: ApiExceptionType.timeout,
  );

  /// Create a no internet connection exception
  factory ApiException.noInternet([String? customMessage]) => ApiException(
    message:
        customMessage ??
        'Немає підключення до інтернету або сервер недоступний',
    type: ApiExceptionType.noInternet,
  );

  /// Create a server error exception
  factory ApiException.serverError(String message, {int? statusCode}) =>
      ApiException(
        message: message,
        type: ApiExceptionType.serverError,
        statusCode: statusCode,
      );

  /// Create a parse error exception
  factory ApiException.parseError([String? customMessage]) => ApiException(
    message: customMessage ?? 'Неочікуваний формат відповіді сервера',
    type: ApiExceptionType.parseError,
  );

  /// Create a cancelled request exception
  factory ApiException.cancelled([String? customMessage]) => ApiException(
    message: customMessage ?? 'Запит скасовано',
    type: ApiExceptionType.cancelled,
  );

  @override
  String toString() {
    return 'ApiException(message: $message, type: $type, statusCode: $statusCode)';
  }

  /// Get user-friendly message for UI display
  String get userMessage => message;

  /// Check if this is a network-related error
  bool get isNetworkError =>
      type == ApiExceptionType.timeout ||
      type == ApiExceptionType.noInternet ||
      type == ApiExceptionType.cancelled;

  /// Check if this is a server error (4xx, 5xx)
  bool get isServerError => type == ApiExceptionType.serverError;

  /// Check if this is a parse error
  bool get isParseError => type == ApiExceptionType.parseError;

  /// Check if the request can be retried (excludes 400 Bad Request)
  bool get canRetry =>
      type == ApiExceptionType.timeout ||
      type == ApiExceptionType.noInternet ||
      (type == ApiExceptionType.serverError && statusCode != 400);
}
