import 'package:equatable/equatable.dart';
import '../../../data/models/address_with_status_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading state while fetching data from server
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// State when data is successfully loaded and displayed
class HomeLoaded extends HomeState {
  final List<AddressWithStatus> addresses;
  final Set<String> expandedAddressIds; // IDs of expanded addresses

  HomeLoaded({
    List<AddressWithStatus>? addresses,
    Set<String>? expandedAddressIds,
  }) : addresses = addresses ?? const [],
       expandedAddressIds = expandedAddressIds ?? <String>{};

  HomeLoaded copyWith({
    List<AddressWithStatus>? addresses,
    Set<String>? expandedAddressIds,
  }) {
    return HomeLoaded(
      addresses: addresses ?? this.addresses,
      expandedAddressIds: expandedAddressIds ?? this.expandedAddressIds,
    );
  }

  @override
  List<Object?> get props => [addresses, expandedAddressIds];
}

/// Error state when data loading fails
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
