import 'package:collection/collection.dart';

import '../models/address_model.dart';
import '../services/address_search_service.dart';
import '../services/local_storage_service.dart';

/// Repository for managing addresses - both search and local storage
class AddressRepository {
  final AddressSearchService _searchService;
  final LocalStorageService _storageService;

  AddressRepository(this._searchService, this._storageService);

  /// Global address search
  Future<List<AddressModel>> searchAddresses(String query) =>
      _searchService.searchAddresses(query);

  /// Get list of cities (with optional filtering)
  Future<List<String>> getCities({String? search}) =>
      _searchService.getCities(search: search);

  /// Get list of streets for specified city
  Future<List<String>> getStreets(String city, {String? search}) =>
      _searchService.getStreets(city, search: search);

  /// Get list of houses for specified city and street
  Future<List<String>> getHouses(
    String city,
    String street, {
    String? search,
  }) => _searchService.getHouses(city, street, search: search);

  /// Get complete address information
  Future<AddressModel?> getAddressInfo(
    String city,
    String street,
    String house,
  ) => _searchService.getAddressInfo(city, street, house);

  /// Get address database statistics
  Future<Map<String, dynamic>> getStatistics() =>
      _searchService.getStatistics();

  // === Legacy methods for single address (for backward compatibility) ===

  /// Save selected address (legacy - for compatibility)
  Future<bool> saveSelectedAddress(AddressModel address) async {
    return await _storageService.saveAddress(address);
  }

  /// Get saved address (legacy - for compatibility)
  /// Made async for consistency with other repository methods
  Future<AddressModel?> getSelectedAddress() async {
    return _storageService.loadAddress();
  }

  /// Clear saved address (legacy - for compatibility)
  Future<bool> clearSelectedAddress() async {
    return await _storageService.clearAddress();
  }

  // === Methods for working with multiple addresses ===

  /// Get all saved addresses
  Future<List<AddressModel>> getSavedAddresses() async {
    return await _storageService.loadAddresses();
  }

  /// Save list of addresses
  /// Returns false if save operation fails
  Future<bool> saveAddresses(List<AddressModel> addresses) async {
    return await _storageService.saveAddresses(addresses);
  }

  /// Add new address
  /// Returns false if address with same ID already exists
  Future<bool> addAddress(AddressModel address) async {
    final addresses = await getSavedAddresses();

    // Check if address already exists (by ID)
    if (addresses.any((a) => a.id == address.id)) {
      return false; // Address already exists
    }

    addresses.add(address);
    return await saveAddresses(addresses);
  }

  /// Update existing address
  /// Returns false if address not found
  Future<bool> updateAddress(AddressModel address) async {
    final addresses = await getSavedAddresses();
    final index = addresses.indexWhere((a) => a.id == address.id);

    if (index == -1) {
      return false; // Address not found
    }

    addresses[index] = address;
    return await saveAddresses(addresses);
  }

  /// Delete address by ID
  /// Always returns true (safe operation even if address doesn't exist)
  Future<bool> deleteAddress(String addressId) async {
    final addresses = await getSavedAddresses();
    addresses.removeWhere((a) => a.id == addressId);
    return await saveAddresses(addresses);
  }

  /// Get address by ID
  /// Returns null if not found
  Future<AddressModel?> getAddressById(String addressId) async {
    final addresses = await getSavedAddresses();
    return addresses.firstWhereOrNull((a) => a.id == addressId);
  }

  /// Check if there are any saved addresses
  Future<bool> hasAddresses() async {
    final addresses = await getSavedAddresses();
    return addresses.isNotEmpty;
  }

  /// Get count of saved addresses
  Future<int> getAddressCount() async {
    final addresses = await getSavedAddresses();
    return addresses.length;
  }

  // === Address Ordering ===

  /// Reorder addresses by moving an address from one position to another
  /// Returns the updated list of addresses in the new order
  Future<List<AddressModel>> reorderAddresses(
    int oldIndex,
    int newIndex,
  ) async {
    final addresses = await getSavedAddresses();

    // Adjust newIndex if moving down (standard ReorderableList behavior)
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Move the address to new position
    final address = addresses.removeAt(oldIndex);
    addresses.insert(newIndex, address);

    // Save the reordered list
    await saveAddresses(addresses);

    // Save the order (list of IDs) for persistence
    await _storageService.saveAddressesOrder(
      addresses.map((a) => a.id).toList(),
    );

    return addresses;
  }

  /// Get addresses sorted by saved order
  /// If no custom order exists, returns addresses in stored order
  Future<List<AddressModel>> getSavedAddressesOrdered() async {
    final addresses = await getSavedAddresses();
    final savedOrder = _storageService.loadAddressesOrder();

    // If no custom order saved, return addresses as-is
    if (savedOrder == null || savedOrder.isEmpty) {
      return addresses;
    }

    // Sort addresses by saved order
    final orderedAddresses = <AddressModel>[];
    final addressMap = {for (var addr in addresses) addr.id: addr};

    // Add addresses in saved order
    for (final id in savedOrder) {
      if (addressMap.containsKey(id)) {
        orderedAddresses.add(addressMap[id]!);
        addressMap.remove(id);
      }
    }

    // Add any remaining addresses that weren't in the saved order
    orderedAddresses.addAll(addressMap.values);

    return orderedAddresses;
  }
}
