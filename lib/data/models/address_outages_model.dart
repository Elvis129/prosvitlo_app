import 'package:equatable/equatable.dart';

import 'outage_info_model.dart';

/// API response model containing outage information for a specific address
class AddressOutagesModel extends Equatable {
  /// City name
  final String city;

  /// Street name
  final String street;

  /// House number
  final String house;

  /// Emergency outages - active
  final List<OutageInfoModel> activeEmergency;

  /// Emergency outages - upcoming
  final List<OutageInfoModel> upcomingEmergency;

  /// Planned outages - active
  final List<OutageInfoModel> activePlanned;

  /// Planned outages - upcoming
  final List<OutageInfoModel> upcomingPlanned;

  const AddressOutagesModel({
    required this.city,
    required this.street,
    required this.house,
    required this.activeEmergency,
    required this.upcomingEmergency,
    required this.activePlanned,
    required this.upcomingPlanned,
  });

  /// Whether there are any active emergency outages
  bool get hasEmergencyOutage => activeEmergency.isNotEmpty;

  /// Whether there are any active planned outages
  bool get hasPlannedOutage => activePlanned.isNotEmpty;

  /// Whether there are any active outages (emergency or planned)
  bool get hasAnyActiveOutage => hasEmergencyOutage || hasPlannedOutage;

  /// Total number of active outages
  int get totalActiveOutages => activeEmergency.length + activePlanned.length;

  /// Total number of upcoming outages
  int get totalUpcomingOutages =>
      upcomingEmergency.length + upcomingPlanned.length;

  /// Gets all active outages (emergency + planned)
  List<OutageInfoModel> get allActiveOutages => [
    ...activeEmergency,
    ...activePlanned,
  ];

  /// Gets all upcoming outages (emergency + planned)
  List<OutageInfoModel> get allUpcomingOutages => [
    ...upcomingEmergency,
    ...upcomingPlanned,
  ];

  /// Helper method to safely parse list of outages from JSON
  static List<OutageInfoModel> _parseList(dynamic value) {
    return (value as List<dynamic>? ?? [])
        .map((e) => OutageInfoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  factory AddressOutagesModel.fromJson(Map<String, dynamic> json) {
    return AddressOutagesModel(
      city: json['city'] as String,
      street: json['street'] as String,
      house: json['house_number'] as String,
      activeEmergency: _parseList(json['active_emergency']),
      upcomingEmergency: _parseList(json['upcoming_emergency']),
      activePlanned: _parseList(json['active_planned']),
      upcomingPlanned: _parseList(json['upcoming_planned']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'house_number': house,
      'active_emergency': activeEmergency.map((e) => e.toJson()).toList(),
      'upcoming_emergency': upcomingEmergency.map((e) => e.toJson()).toList(),
      'active_planned': activePlanned.map((e) => e.toJson()).toList(),
      'upcoming_planned': upcomingPlanned.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    city,
    street,
    house,
    activeEmergency,
    upcomingEmergency,
    activePlanned,
    upcomingPlanned,
  ];
}
