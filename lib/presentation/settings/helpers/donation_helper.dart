import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/donation_info_model.dart';
import '../../../data/services/log_color.dart';
import '../../about/widgets/donation_card_dialog.dart';

/// Helper class for handling donation URL launching
class DonationHelper {
  DonationHelper._();

  /// Opens donation link or shows error with card number option
  static Future<void> openDonationLink(
    BuildContext context,
    DonationInfoModel donationInfo,
  ) async {
    final url = donationInfo.url;
    final cardNumber = donationInfo.cardNumber;

    if (url.isEmpty) return;

    // Capture before async operations
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    final Uri donationUrl = Uri.parse(url);

    try {
      if (!await launchUrl(donationUrl, mode: LaunchMode.externalApplication)) {
        if (context.mounted && cardNumber != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.errorOpeningLink),
              backgroundColor: AppColors.error,
              action: SnackBarAction(
                label: l10n.copy,
                textColor: Colors.white,
                onPressed: () {
                  DonationCardDialog.show(context, donationInfo);
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      logError('Error opening donation link: $e');
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.errorGeneric(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
