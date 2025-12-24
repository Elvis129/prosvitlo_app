import 'package:equatable/equatable.dart';

import 'outage_status.dart';

/// Model representing a user's address with power outage information
class AddressModel extends Equatable {
  /// City name
  final String city;

  /// Street name
  final String street;

  /// House number
  final String house;

  /// Building/corpus number (optional)
  final String? building;

  /// Apartment number (optional)
  final String? apartment;

  /// Power outage queue identifier (e.g., "6.2. підчерга")
  final String queue;

  /// URL to the source of outage information
  final String? sourceUrl;

  /// Current power outage status
  final OutageStatus outageStatus;

  /// User-defined name for this address (e.g., "Дім", "Робота")
  final String name;

  const AddressModel({
    required this.city,
    required this.street,
    required this.house,
    this.building,
    this.apartment,
    required this.queue,
    this.sourceUrl,
    this.outageStatus = OutageStatus.unknown,
    this.name = 'Дім', // Default value
  });

  /// Address ID generated from main parameters
  /// Normalized to avoid duplicates due to different cases and whitespace
  String get id =>
      '${city.trim().toLowerCase()}|'
      '${street.trim().toLowerCase()}|'
      '${house.trim().toLowerCase()}|'
      '${building?.trim().toLowerCase() ?? ''}|'
      '${apartment?.trim().toLowerCase() ?? ''}';

  /// Queue number (numeric part only)
  int get queueNumber {
    final match = RegExp(r'(\d+)').firstMatch(queue);
    return int.tryParse(match?.group(1) ?? '') ?? 0;
  }

  /// Sub-queue identifier (e.g., "6.2" -> "2")
  String? get subQueue {
    final match = RegExp(r'\d+\.(\d+)').firstMatch(queue);
    return match?.group(1);
  }

  /// Full formatted address string
  String get fullAddress {
    final parts = [city, street, 'буд. $house'];
    if (building != null && building!.isNotEmpty) {
      parts.add('корп. $building');
    }
    if (apartment != null && apartment!.isNotEmpty) {
      parts.add('кв. $apartment');
    }
    return parts.join(', ');
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'] as String,
      street: json['street'] as String,
      house: json['house'] as String,
      building: json['building'] as String?,
      apartment: json['apartment'] as String?,
      queue: json['queue'] as String,
      sourceUrl: json['source_url'] as String?,
      outageStatus: OutageStatus.fromString(json['outage_status'] as String?),
      name: json['name'] as String? ?? 'Дім',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'house': house,
      'building': building,
      'apartment': apartment,
      'queue': queue,
      'source_url': sourceUrl,
      'outage_status': outageStatus.toJson(),
      'name': name,
    };
  }

  AddressModel copyWith({
    String? city,
    String? street,
    String? house,
    String? building,
    String? apartment,
    String? queue,
    String? sourceUrl,
    OutageStatus? outageStatus,
    String? name,
  }) {
    return AddressModel(
      city: city ?? this.city,
      street: street ?? this.street,
      house: house ?? this.house,
      building: building ?? this.building,
      apartment: apartment ?? this.apartment,
      queue: queue ?? this.queue,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      outageStatus: outageStatus ?? this.outageStatus,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [
    city,
    street,
    house,
    building,
    apartment,
    queue,
    sourceUrl,
    outageStatus,
    name,
  ];
}
