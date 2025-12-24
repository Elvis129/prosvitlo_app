import '../models/outage_status_model.dart';
import '../models/address_model.dart';
import '../models/address_outages_model.dart';
import '../services/outage_service.dart';

class OutageRepository {
  final OutageService _outageService;

  OutageRepository(this._outageService);

  Future<OutageStatusModel> getStatus(
    String addressId, {
    String? scheduleDate,
  }) {
    return _outageService.getStatus(addressId, scheduleDate: scheduleDate);
  }

  /// Get statuses for multiple addresses simultaneously
  Future<Map<String, OutageStatusModel>> getMultipleStatuses(
    List<AddressModel> addresses, {
    String? scheduleDate,
  }) {
    return _outageService.getMultipleStatuses(
      addresses,
      scheduleDate: scheduleDate,
    );
  }

  /// Get information about emergency and planned outages
  Future<AddressOutagesModel> getAddressOutages(
    String city,
    String street,
    String house,
  ) {
    return _outageService.getAddressOutages(city, street, house);
  }
}
