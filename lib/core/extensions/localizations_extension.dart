import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

extension LocalizationsExtension on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    // Use StateError instead of FlutterError to avoid potential recursion
    if (localizations == null) {
      throw StateError('AppLocalizations not available in this context');
    }
    return localizations;
  }
}
