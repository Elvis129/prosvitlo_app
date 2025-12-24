import 'package:equatable/equatable.dart';
import '../../../data/models/address_model.dart';

/// Base state for address search feature
abstract class AddressSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state when the screen is first opened
class AddressSearchInitial extends AddressSearchState {}

/// Loading state when fetching initial data (cities)
class AddressSearchLoading extends AddressSearchState {}

/// Main state containing address search data and results
/// Used during cascade selection (city → street → house)
class AddressSearchLoaded extends AddressSearchState {
  final List<AddressModel> results;
  final List<String> cities;
  final List<String> streets;
  final List<String> houses;
  final String? selectedCity;
  final String? selectedStreet;
  final String? errorMessage;

  AddressSearchLoaded({
    this.results = const [],
    this.cities = const [],
    this.streets = const [],
    this.houses = const [],
    this.selectedCity,
    this.selectedStreet,
    this.errorMessage,
  });

  AddressSearchLoaded copyWith({
    List<AddressModel>? results,
    List<String>? cities,
    List<String>? streets,
    List<String>? houses,
    String? selectedCity,
    String? selectedStreet,
    String? errorMessage,
    bool clearCity = false,
    bool clearStreet = false,
    bool clearError = false,
  }) {
    return AddressSearchLoaded(
      results: results ?? this.results,
      cities: cities ?? this.cities,
      streets: streets ?? this.streets,
      houses: houses ?? this.houses,
      selectedCity: clearCity ? null : (selectedCity ?? this.selectedCity),
      selectedStreet: clearStreet
          ? null
          : (selectedStreet ?? this.selectedStreet),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    results,
    cities,
    streets,
    houses,
    selectedCity,
    selectedStreet,
    errorMessage,
  ];
}

/// State when saving address to database
class AddressSearchSaving extends AddressSearchState {}

/// State when house is selected and waiting for user to enter address name
class AddressSearchNeedName extends AddressSearchState {
  final AddressModel address;

  AddressSearchNeedName(this.address);

  @override
  List<Object?> get props => [address];
}

/// State when address is successfully saved
class AddressSearchSaved extends AddressSearchState {}

/// General error state for address search operations
class AddressSearchError extends AddressSearchState {
  final String message;
  final AddressSearchLoaded? previousState;

  AddressSearchError({required this.message, this.previousState});

  @override
  List<Object?> get props => [message, previousState];
}

/// Network error state - extends general error for network-specific issues
class AddressSearchNetworkError extends AddressSearchError {
  AddressSearchNetworkError({required super.message, super.previousState});
}

/// Validation error (invalid input, missing required fields)
class AddressSearchValidationError extends AddressSearchError {
  AddressSearchValidationError({required super.message, super.previousState});
}
