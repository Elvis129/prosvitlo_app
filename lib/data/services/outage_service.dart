import '../models/outage_status_model.dart';
import '../models/address_model.dart';
import '../models/address_outages_model.dart';
import 'api_client.dart';
import 'api_exception.dart';
import 'log_color.dart';
import 'service_strings.dart';

/// Service for fetching power outage information
/// Handles status checks and outage details for addresses
class OutageService {
  final ApiClient _apiClient;

  OutageService(this._apiClient);

  /// Get statuses for multiple addresses simultaneously (OPTIMIZED: batch request)
  /// Returns a map of addressId -> OutageStatusModel
  Future<Map<String, OutageStatusModel>> getMultipleStatuses(
    List<AddressModel> addresses, {
    String? scheduleDate,
  }) async {
    final Map<String, OutageStatusModel> results = {};

    if (addresses.isEmpty) {
      return results;
    }

    try {
      // Format batch request
      final addressesData = addresses.map((address) {
        return {
          'city': address.city,
          'street': address.street,
          'house': address.house,
        };
      }).toList();

      final requestBody = {
        'addresses': addressesData,
        if (scheduleDate != null) 'schedule_date': scheduleDate,
      };

      // Single request instead of N requests!
      final response = await _apiClient.post(
        '/schedules/batch-status',
        data: requestBody,
      );

      // Parse response data
      final responseData = response.data as Map<String, dynamic>;
      final List<dynamic> statuses = responseData['statuses'] as List<dynamic>;

      logInfo(
        '[OutageService] Batch request successful: ${statuses.length} statuses received',
      );

      // Convert responses to models
      for (int i = 0; i < statuses.length && i < addresses.length; i++) {
        final data = statuses[i] as Map<String, dynamic>;
        final address = addresses[i];

        final hasPower = data['has_power'] as bool? ?? true;
        final upcomingList = data['upcoming_outages'] as List<dynamic>? ?? [];

        results[address.id] = OutageStatusModel(
          addressId: address.id,
          status: hasPower ? PowerStatus.on : PowerStatus.off,
          queue: data['queue'] as String? ?? '',
          lastUpdated: DateTime.now(),
          notes: data['message'] as String? ?? ServiceStrings.checkSchedule,
          sourceUrl: data['schedule_image_url'] as String?,
          upcomingOutages: upcomingList
              .map((e) => OutageInterval.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }

      return results;
    } on ApiException {
      rethrow;
    } catch (e) {
      // On error, return error status for all addresses
      logError('[OutageService] Batch request failed: $e');
      for (final address in addresses) {
        results[address.id] = OutageStatusModel(
          addressId: address.id,
          status: PowerStatus.unknown,
          queue: address.queue,
          lastUpdated: DateTime.now(),
          notes: ServiceStrings.errorGettingData,
          upcomingOutages: [],
        );
      }
      return results;
    }
  }

  /// Get power outage status for a single address
  /// [addressId] Address identifier in format: "city|street|house|building|apartment"
  /// [scheduleDate] Optional date for schedule lookup (format: YYYY-MM-DD)
  Future<OutageStatusModel> getStatus(
    String addressId, {
    String? scheduleDate,
  }) async {
    try {
      // Split addressId into components (format: "city|street|house|...")
      final parts = addressId.split('|');
      if (parts.length < 3) {
        throw ApiException.parseError(ServiceStrings.invalidAddress);
      }

      final city = parts[0];
      final street = parts[1];
      final house = parts[2];

      // Format request parameters
      final queryParams = {'city': city, 'street': street, 'house': house};

      // Add date if specified
      if (scheduleDate != null) {
        queryParams['schedule_date'] = scheduleDate;
      }

      // Get status from API endpoint
      final data = await _apiClient.get(
        '/schedules/status',
        queryParameters: queryParams,
      );

      // Convert API response to model
      final hasPower = data['has_power'] as bool? ?? true;
      final upcomingList = data['upcoming_outages'] as List<dynamic>? ?? [];

      logInfo(
        '[OutageService] Status fetched for $addressId: ${hasPower ? 'power on' : 'power off'}',
      );

      return OutageStatusModel(
        addressId: addressId,
        status: hasPower ? PowerStatus.on : PowerStatus.off,
        queue: data['queue'] as String? ?? '',
        lastUpdated: DateTime.now(),
        notes: data['message'] as String? ?? ServiceStrings.checkSchedule,
        sourceUrl: data['schedule_image_url'] as String?,
        upcomingOutages: upcomingList
            .map((e) => OutageInterval.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: ServiceStrings.errorGettingStatus(e),
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Get information about emergency and planned outages for an address
  Future<AddressOutagesModel> getAddressOutages(
    String city,
    String street,
    String house,
  ) async {
    try {
      final response = await _apiClient.get(
        '/address-outages',
        queryParameters: {'city': city, 'street': street, 'house': house},
      );

      logInfo('[OutageService] Outages fetched for $city, $street, $house');
      return AddressOutagesModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: ServiceStrings.errorGettingOutages(e),
        type: ApiExceptionType.unknown,
      );
    }
  }
}
