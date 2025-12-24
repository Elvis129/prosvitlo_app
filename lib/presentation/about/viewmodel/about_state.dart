import 'package:equatable/equatable.dart';
import '../../../data/models/donation_info_model.dart';

/// About screen state
sealed class AboutState extends Equatable {
  const AboutState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AboutInitial extends AboutState {
  const AboutInitial();
}

/// Loading state
class AboutLoading extends AboutState {
  const AboutLoading();
}

/// Loaded state with app version and donation info
class AboutLoaded extends AboutState {
  final String appVersion;
  final DonationInfoModel? donationInfo;

  const AboutLoaded({required this.appVersion, this.donationInfo});

  @override
  List<Object?> get props => [appVersion, donationInfo?.url];
}

/// Error state
class AboutError extends AboutState {
  final String message;

  const AboutError(this.message);

  @override
  List<Object> get props => [message];
}
