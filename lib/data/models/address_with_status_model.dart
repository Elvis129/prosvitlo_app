import 'package:equatable/equatable.dart';
import 'address_model.dart';
import 'outage_status_model.dart';
import 'address_outages_model.dart';

/// Model combining address with its outage status and loading state
/// Note: toJson/fromJson only serialize data fields, not UI state (isLoading, error)
class AddressWithStatus extends Equatable {
  /// Address information
  final AddressModel address;

  /// Current day outage status
  final OutageStatusModel? status;

  /// Tomorrow's outage status
  final OutageStatusModel? tomorrowStatus;

  /// Emergency and planned outages
  final AddressOutagesModel? outages;

  /// Loading state (not serialized)
  final bool isLoading;

  /// Error message (not serialized)
  final String? error;

  /// Last data update timestamp
  final DateTime? lastUpdated;

  /// Sentinel value for copyWith to distinguish null from unset
  static const _unset = Object();

  /// Whether there's an error
  bool get hasError => error != null;

  /// Whether there are any active outages
  bool get hasActiveOutage => outages?.hasAnyActiveOutage ?? false;

  /// Whether data is ready (loaded without errors and has status)
  bool get isReady => !isLoading && error == null && status != null;

  const AddressWithStatus({
    required this.address,
    this.status,
    this.tomorrowStatus,
    this.outages,
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  AddressWithStatus copyWith({
    AddressModel? address,
    OutageStatusModel? status,
    OutageStatusModel? tomorrowStatus,
    AddressOutagesModel? outages,
    bool? isLoading,
    Object? error = _unset,
    DateTime? lastUpdated,
  }) {
    return AddressWithStatus(
      address: address ?? this.address,
      status: status ?? this.status,
      tomorrowStatus: tomorrowStatus ?? this.tomorrowStatus,
      outages: outages ?? this.outages,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Serializes to JSON for local cache
  /// Note: isLoading and error are UI state and not serialized
  Map<String, dynamic> toJson() {
    return {
      'address': address.toJson(),
      'status': status?.toJson(),
      'tomorrowStatus': tomorrowStatus?.toJson(),
      'outages': outages?.toJson(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  /// Deserializes from JSON (local cache)
  /// Note: isLoading and error are not deserialized (default values used)
  factory AddressWithStatus.fromJson(Map<String, dynamic> json) {
    return AddressWithStatus(
      address: AddressModel.fromJson(json['address']),
      status: json['status'] != null
          ? OutageStatusModel.fromJson(json['status'])
          : null,
      tomorrowStatus: json['tomorrowStatus'] != null
          ? OutageStatusModel.fromJson(json['tomorrowStatus'])
          : null,
      outages: json['outages'] != null
          ? AddressOutagesModel.fromJson(json['outages'])
          : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated']).toLocal()
          : null,
    );
  }

  @override
  List<Object?> get props => [
    address,
    status,
    tomorrowStatus,
    outages,
    isLoading,
    error,
    lastUpdated,
  ];
}
