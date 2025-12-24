import 'package:dio/dio.dart';
import '../models/schedule_model.dart';
import 'api_exception.dart';
import 'log_color.dart';
import 'service_strings.dart';

/// Service for fetching power outage schedules
/// Handles schedule images and date-based lookups
class ScheduleService {
  final Dio _dio;
  final String _baseUrl;

  ScheduleService({
    Dio? dio,
    String baseUrl = 'https://prosvitlo-backend.fly.dev/api/v1',
  }) : _dio = dio ?? Dio(),
       _baseUrl = baseUrl {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  /// Normalize image URL for current platform
  ///
  /// This is primarily for local development environments where the backend
  /// might return URLs with localhost/10.0.2.2 that don't work on all devices.
  /// In production (fly.dev), the server returns correct public URLs.
  String _normalizeImageUrl(String imageUrl) {
    // Skip if already using production URL or relative path
    if (imageUrl.contains('prosvitlo-backend.fly.dev') ||
        !imageUrl.contains('://')) {
      return imageUrl;
    }

    // Extract host from baseUrl (e.g., 192.168.0.198:8000, 10.0.2.2:8000)
    final uri = Uri.parse(_baseUrl);
    final correctHost = '${uri.host}:${uri.port}';

    // Replace any host with the correct one for local development
    return imageUrl.replaceAllMapped(
      RegExp(r'https?://([^/]+)/'),
      (match) => '${uri.scheme}://$correctHost/',
    );
  }

  /// Parse schedule from JSON and normalize image URL
  ScheduleModel _parseSchedule(Map<String, dynamic> json) {
    final schedule = ScheduleModel.fromJson(json);
    // Return new instance with normalized image URL
    return ScheduleModel(
      id: schedule.id,
      date: schedule.date,
      imageUrl: _normalizeImageUrl(schedule.imageUrl),
      altText: schedule.altText,
      version: schedule.version,
      createdAt: schedule.createdAt,
      updatedAt: schedule.updatedAt,
    );
  }

  /// Handle Dio errors and convert to ApiException
  Never _handleDioError(DioException error, String context) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      throw ApiException.timeout(ServiceStrings.timeout);
    } else if (error.type == DioExceptionType.connectionError) {
      throw ApiException.noInternet(ServiceStrings.connectionError);
    } else if (error.response?.statusCode == 404) {
      throw ApiException.serverError(
        ServiceStrings.scheduleNotFound,
        statusCode: 404,
      );
    } else {
      throw ApiException(
        message: '$context: ${error.message}',
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Get current outage schedules
  /// [limit] Maximum number of schedules to return (default: 7)
  Future<List<ScheduleModel>> getCurrentSchedules({int limit = 7}) async {
    try {
      final response = await _dio.get(
        '/schedules/current',
        queryParameters: {'limit': limit},
      );

      if (response.statusCode != 200) {
        throw ApiException.serverError(
          ServiceStrings.errorLoadingSchedule,
          statusCode: response.statusCode,
        );
      }

      // Type safety check
      if (response.data is! List) {
        throw ApiException.parseError(ServiceStrings.invalidResponse);
      }

      final List<dynamic> data = response.data as List;
      final schedules = data
          .map((json) => _parseSchedule(json as Map<String, dynamic>))
          .toList();

      logInfo('[ScheduleService] Fetched ${schedules.length} schedules');
      return schedules;
    } on DioException catch (e) {
      _handleDioError(e, ServiceStrings.networkError);
    } on ApiException {
      rethrow;
    } catch (e) {
      logError('[ScheduleService] Unknown error: $e');
      throw ApiException(
        message: ServiceStrings.unknownError(e),
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Get the latest schedule
  Future<ScheduleModel> getLatestSchedule() async {
    try {
      final response = await _dio.get('/schedules/latest');

      if (response.statusCode != 200) {
        throw ApiException.serverError(
          ServiceStrings.errorLoadingLatestSchedule,
          statusCode: response.statusCode,
        );
      }

      final schedule = _parseSchedule(response.data as Map<String, dynamic>);
      logInfo('[ScheduleService] Fetched latest schedule for ${schedule.date}');
      return schedule;
    } on DioException catch (e) {
      _handleDioError(e, ServiceStrings.networkError);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: ServiceStrings.unknownError(e),
        type: ApiExceptionType.unknown,
      );
    }
  }
}
