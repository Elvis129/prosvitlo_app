import 'package:equatable/equatable.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/donation_info_model.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final String themeMode;
  final bool notificationsEnabled;
  final List<AddressModel> addresses;
  final DonationInfoModel? donationInfo;

  SettingsLoaded({
    required this.themeMode,
    required this.notificationsEnabled,
    this.addresses = const [],
    this.donationInfo,
  });

  SettingsLoaded copyWith({
    String? themeMode,
    bool? notificationsEnabled,
    List<AddressModel>? addresses,
    DonationInfoModel? donationInfo,
  }) {
    return SettingsLoaded(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      addresses: addresses ?? this.addresses,
      donationInfo: donationInfo ?? this.donationInfo,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    notificationsEnabled,
    addresses,
    donationInfo,
  ];
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
