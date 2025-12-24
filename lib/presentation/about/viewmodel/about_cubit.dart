import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../data/repositories/donation_repository.dart';
import '../../../data/services/log_color.dart';
import 'about_state.dart';

/// Cubit for About screen
class AboutCubit extends Cubit<AboutState> {
  final DonationRepository _donationRepository;

  AboutCubit(this._donationRepository) : super(const AboutInitial());

  /// Load about screen data (app version + donation info)
  Future<void> loadAboutInfo() async {
    try {
      emit(const AboutLoading());

      // Load app version
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;

      // Load donation info
      final donationInfo = await _donationRepository.getDonationInfo();

      emit(AboutLoaded(appVersion: appVersion, donationInfo: donationInfo));

      logInfo('[AboutCubit] About info loaded successfully');
    } catch (e, stackTrace) {
      logError('[AboutCubit] Failed to load about info: $e\n$stackTrace');
      emit(AboutError('Failed to load app information: $e'));
    }
  }
}
