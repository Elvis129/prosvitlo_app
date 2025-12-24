import 'package:dio/dio.dart';
import 'package:prosvitlo_app/data/services/log_color.dart';
import 'api_exception.dart';
import 'service_strings.dart';

/// HTTP client for API communication using Dio
/// Handles requests, responses, and error mapping to [ApiException]
class ApiClient {
  final Dio _dio;
  final String baseUrl;

  ApiClient({this.baseUrl = 'https://prosvitlo-backend.fly.dev/api/v1'})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json',
          },
        ),
      ) {
    // Add logging only in debug mode to avoid production logs
    bool isDebugMode = false;
    assert(() {
      isDebugMode = true;
      return true;
    }());

    if (isDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  /// Perform GET request expecting a JSON object response
  /// Throws [ApiException] if response is not a Map
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          message: ServiceStrings.unexpectedResponseFormat,
          type: ApiExceptionType.parseError,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        message: ServiceStrings.unexpectedError(e),
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Perform GET request expecting a JSON array response
  /// Throws [ApiException] if response is not a List
  Future<List<dynamic>> getList(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return response.data as List<dynamic>;
      } else {
        throw ApiException(
          message: ServiceStrings.unexpectedResponseFormat,
          type: ApiExceptionType.parseError,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        message: ServiceStrings.unexpectedError(e),
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Perform POST request with optional data and query parameters
  /// Returns raw [Response] for flexible handling in repositories
  Future<Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        message: ServiceStrings.unexpectedError(e),
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Perform PATCH request with optional data and query parameters
  /// Returns raw [Response] for flexible handling in repositories
  Future<Response> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        message: ServiceStrings.unexpectedError(e),
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Perform DELETE request with optional data and query parameters
  /// Returns raw [Response] for flexible handling in repositories
  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(
        message: ServiceStrings.unexpectedError(e),
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Map Dio errors to custom [ApiException] with user-friendly Ukrainian messages
  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: ServiceStrings.requestTimeout,
          type: ApiExceptionType.timeout,
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        // Map of status codes to Ukrainian user-facing messages
        final statusMessages = {
          400: ServiceStrings.badRequest,
          404: ServiceStrings.notFound,
          500: ServiceStrings.serverError,
          503: ServiceStrings.serviceUnavailable,
        };

        final message =
            statusMessages[statusCode] ??
            ServiceStrings.serverErrorWithCode(statusCode);

        return ApiException(
          message: message,
          type: ApiExceptionType.serverError,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: ServiceStrings.requestCancelled,
          type: ApiExceptionType.cancelled,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: ServiceStrings.noConnection,
          type: ApiExceptionType.noInternet,
        );

      default:
        bool isDebugMode = false;
        assert(() {
          isDebugMode = true;
          return true;
        }());

        if (isDebugMode) {
          logError('[ApiClient] Unhandled DioException type: ${error.type}');
        }
        return ApiException(
          message: ServiceStrings.connectionFailed,
          type: ApiExceptionType.unknown,
        );
    }
  }
}
