import 'package:flutter/material.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../data/models/donation_info_model.dart';
import '../../../data/services/log_color.dart';

/// Dialog for displaying donation card number
class DonationCardDialog extends StatelessWidget {
  final DonationInfoModel donationInfo;

  const DonationCardDialog({required this.donationInfo, super.key});

  static Future<void> show(
    BuildContext context,
    DonationInfoModel donationInfo,
  ) async {
    if (donationInfo.cardNumber == null || donationInfo.cardNumber!.isEmpty) {
      logWarning('[DonationCardDialog] Card number is empty');
      return;
    }

    return showDialog<void>(
      context: context,
      builder: (context) => DonationCardDialog(donationInfo: donationInfo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.donationCardNumberTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.donationCardNumberLabel),
          const SizedBox(height: 8),
          SelectableText(
            donationInfo.cardNumber!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.close),
        ),
      ],
    );
  }
}
