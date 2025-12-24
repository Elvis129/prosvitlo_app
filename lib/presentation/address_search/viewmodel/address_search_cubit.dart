import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../data/services/api_exception.dart';
import '../../../data/models/address_model.dart';
import 'address_search_state.dart';

/// Manages cascade address selection: city → street → house
class AddressSearchCubit extends Cubit<AddressSearchState> {
  final AddressRepository _addressRepository;
  AddressSearchLoaded? _lastLoadedState;
  Timer? _searchDebounceTimer;

  static const _debounceDuration = Duration(milliseconds: 500);

  AddressSearchCubit(this._addressRepository) : super(AddressSearchInitial());

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }

  /// Loads initial list of cities
  Future<void> loadInitialData() async {
    emit(AddressSearchLoading());

    try {
      final cities = await _addressRepository.getCities();
      final loadedState = AddressSearchLoaded(cities: cities);
      _lastLoadedState = loadedState;
      emit(loadedState);
    } on ApiException catch (e) {
      emit(AddressSearchNetworkError(message: e.userMessage));
    } catch (e) {
      emit(AddressSearchError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  /// Searches cities with debounce
  Future<void> searchCities(String query) async {
    final currentState = state;
    if (currentState is! AddressSearchLoaded) return;

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(_debounceDuration, () async {
      try {
        final cities = await _addressRepository.getCities(search: query);
        final loadedState = currentState.copyWith(
          cities: cities,
          clearStreet: true,
        );
        _lastLoadedState = loadedState;
        emit(loadedState);
      } on ApiException catch (e) {
        emit(
          AddressSearchNetworkError(
            message: e.userMessage,
            previousState: _lastLoadedState,
          ),
        );
      } catch (e) {
        emit(
          AddressSearchError(
            message: 'Error searching cities: ${e.toString()}',
          ),
        );
      }
    });
  }

  /// Selects city and clears dependent fields
  Future<void> selectCity(String city) async {
    final currentState = state;
    if (currentState is! AddressSearchLoaded) return;

    try {
      final loadedState = currentState.copyWith(
        selectedCity: city,
        streets: [],
        houses: [],
        clearStreet: true,
      );
      _lastLoadedState = loadedState;
      emit(loadedState);
    } catch (e) {
      final errorState = currentState.copyWith(
        errorMessage: 'Error selecting city: ${e.toString()}',
      );
      emit(errorState);
    }
  }

  /// Searches streets in selected city with debounce
  Future<void> searchStreets(String query) async {
    final currentState = state;
    if (currentState is! AddressSearchLoaded ||
        currentState.selectedCity == null) {
      return;
    }

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(_debounceDuration, () async {
      try {
        final streets = await _addressRepository.getStreets(
          currentState.selectedCity!,
          search: query,
        );
        final loadedState = currentState.copyWith(
          streets: streets,
          clearError: true,
        );
        _lastLoadedState = loadedState;
        emit(loadedState);
      } on ApiException catch (e) {
        final errorState = currentState.copyWith(errorMessage: e.userMessage);
        emit(errorState);
      } catch (e) {
        final errorState = currentState.copyWith(
          errorMessage: 'Error searching streets: ${e.toString()}',
        );
        emit(errorState);
      }
    });
  }

  /// Selects street and loads available houses
  Future<void> selectStreet(String street) async {
    final currentState = state;
    if (currentState is! AddressSearchLoaded ||
        currentState.selectedCity == null) {
      return;
    }

    try {
      final houses = await _addressRepository.getHouses(
        currentState.selectedCity!,
        street,
      );
      final loadedState = currentState.copyWith(
        selectedStreet: street,
        houses: houses,
      );
      _lastLoadedState = loadedState;
      emit(loadedState);
    } on ApiException catch (e) {
      emit(
        AddressSearchNetworkError(
          message: e.userMessage,
          previousState: _lastLoadedState,
        ),
      );
    } catch (e) {
      emit(
        AddressSearchError(message: 'Error loading houses: ${e.toString()}'),
      );
    }
  }

  /// Searches houses on selected street with debounce
  Future<void> searchHouses(String query) async {
    final currentState = state;
    if (currentState is! AddressSearchLoaded ||
        currentState.selectedCity == null ||
        currentState.selectedStreet == null) {
      return;
    }

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(_debounceDuration, () async {
      try {
        final houses = await _addressRepository.getHouses(
          currentState.selectedCity!,
          currentState.selectedStreet!,
          search: query,
        );
        final loadedState = currentState.copyWith(
          houses: houses,
          clearError: true,
        );
        _lastLoadedState = loadedState;
        emit(loadedState);
      } on ApiException catch (e) {
        final errorState = currentState.copyWith(errorMessage: e.userMessage);
        emit(errorState);
      } catch (e) {
        final errorState = currentState.copyWith(
          errorMessage: 'Error searching houses: ${e.toString()}',
        );
        emit(errorState);
      }
    });
  }

  /// Selects house and gets full address information
  Future<void> selectHouse(String house) async {
    final currentState = state;
    if (currentState is! AddressSearchLoaded ||
        currentState.selectedCity == null ||
        currentState.selectedStreet == null) {
      return;
    }

    _lastLoadedState = currentState;
    emit(AddressSearchSaving());

    try {
      final addressInfo = await _addressRepository.getAddressInfo(
        currentState.selectedCity!,
        currentState.selectedStreet!,
        house,
      );

      if (addressInfo != null) {
        await _addressRepository.saveSelectedAddress(addressInfo);
        emit(AddressSearchNeedName(addressInfo));
      } else {
        if (_lastLoadedState != null) {
          emit(
            _lastLoadedState!.copyWith(errorMessage: 'Error loading address'),
          );
        }
      }
    } on ApiException catch (e) {
      if (_lastLoadedState != null) {
        emit(_lastLoadedState!.copyWith(errorMessage: e.userMessage));
      }
    } catch (e) {
      if (_lastLoadedState != null) {
        emit(
          _lastLoadedState!.copyWith(
            errorMessage: 'Error saving address: ${e.toString()}',
          ),
        );
      }
    }
  }

  /// Saves address with user-provided name to the list
  Future<void> saveAddressWithName(AddressModel address, String name) async {
    emit(AddressSearchSaving());

    try {
      final updatedAddress = address.copyWith(name: name);
      final success = await _addressRepository.addAddress(updatedAddress);

      if (success) {
        emit(AddressSearchSaved());
      } else {
        if (_lastLoadedState != null) {
          emit(
            _lastLoadedState!.copyWith(errorMessage: 'Address already added'),
          );
        }
      }
    } catch (e) {
      if (_lastLoadedState != null) {
        emit(
          _lastLoadedState!.copyWith(
            errorMessage: 'Error saving address: ${e.toString()}',
          ),
        );
      }
    }
  }

  /// Clears city selection and all dependent fields
  void clearCity() {
    _clearDependentFields(clearCity: true, clearStreet: true);
  }

  /// Clears street selection and all dependent fields
  void clearStreet() {
    _clearDependentFields(clearStreet: true);
  }

  /// Helper method to clear cascade fields
  void _clearDependentFields({
    bool clearCity = false,
    bool clearStreet = false,
  }) {
    final currentState = state;
    if (currentState is! AddressSearchLoaded) return;

    final loadedState = currentState.copyWith(
      clearCity: clearCity,
      clearStreet: clearStreet,
      streets: clearCity ? [] : null,
      houses: (clearCity || clearStreet) ? [] : null,
    );
    _lastLoadedState = loadedState;
    emit(loadedState);
  }

  /// Deletes address by ID
  Future<void> deleteAddress(String addressId) async {
    await _addressRepository.deleteAddress(addressId);
  }

  /// Clears error message in current state
  void clearError() {
    final currentState = state;
    if (currentState is AddressSearchLoaded &&
        currentState.errorMessage != null) {
      final loadedState = currentState.copyWith(clearError: true);
      _lastLoadedState = loadedState;
      emit(loadedState);
    }
  }
}
