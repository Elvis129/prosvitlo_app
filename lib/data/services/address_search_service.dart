import '../models/address_model.dart';
import 'api_client.dart';
import 'api_exception.dart';

class AddressSearchService {
  final ApiClient _apiClient;

  AddressSearchService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Search for addresses (via API endpoint /addresses/search)
  Future<List<AddressModel>> searchAddresses(String query) async {
    if (query.isEmpty) return [];

    try {
      final data = await _apiClient.get(
        '/addresses/search',
        queryParameters: {'query': query},
      );

      final results = data['results'] as List<dynamic>? ?? [];
      return results
          .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Помилка при пошуку адрес: $e',
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Get list of cities (with optional filtering)
  Future<List<String>> getCities({String? search}) async {
    try {
      final trimmedSearch = search?.trim();
      final data = await _apiClient.get(
        '/addresses/cities',
        queryParameters: trimmedSearch != null && trimmedSearch.isNotEmpty
            ? {'search': trimmedSearch}
            : null,
      );

      return List<String>.from(data['cities'] ?? []);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Помилка при отриманні списку міст: $e',
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Get list of streets for specified city
  Future<List<String>> getStreets(String city, {String? search}) async {
    try {
      final queryParams = <String, dynamic>{'city': city};
      final trimmedSearch = search?.trim();
      if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
        queryParams['search'] = trimmedSearch;
      }

      final data = await _apiClient.get(
        '/addresses/streets',
        queryParameters: queryParams,
      );

      return List<String>.from(data['streets'] ?? []);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Помилка при отриманні списку вулиць: $e',
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Get list of houses for specified city and street
  Future<List<String>> getHouses(
    String city,
    String street, {
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{'city': city, 'street': street};
      final trimmedSearch = search?.trim();
      if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
        queryParams['search'] = trimmedSearch;
      }

      final data = await _apiClient.get(
        '/addresses/houses',
        queryParameters: queryParams,
      );

      return List<String>.from(data['houses'] ?? []);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Помилка при отриманні списку будинків: $e',
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Get full information about an address
  Future<AddressModel?> getAddressInfo(
    String city,
    String street,
    String house,
  ) async {
    try {
      final data = await _apiClient.get(
        '/addresses/info',
        queryParameters: {'city': city, 'street': street, 'house': house},
      );

      if (data.isEmpty) return null;
      return AddressModel.fromJson(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Помилка при отриманні інформації про адресу: $e',
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Get address database statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await _apiClient.get('/addresses/statistics');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Помилка при отриманні статистики: $e',
        type: ApiExceptionType.unknown,
      );
    }
  }
}
