import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../data/repositories/settings_repository.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SettingsRepository _settingsRepository;
  final ValueNotifier<bool> _onboardingCompleteNotifier;

  OnboardingCubit(this._settingsRepository, this._onboardingCompleteNotifier)
    : super(OnboardingInitial());

  Future<void> completeOnboarding(BuildContext context) async {
    // Capture localization before async gap
    final l10n = context.l10n;

    emit(OnboardingLoading());

    try {
      await _settingsRepository.saveOnboardingComplete();
      // Update the notifier to trigger router refresh
      _onboardingCompleteNotifier.value = true;
      emit(OnboardingCompleted());
    } catch (e) {
      emit(OnboardingError(l10n.errorSavingOnboarding(e.toString())));
    }
  }
}
