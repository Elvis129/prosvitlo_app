import 'package:flutter/material.dart';
import '../../../../core/extensions/localizations_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Dialog to confirm notifications disabling
class ConfirmDisableNotificationsDialog extends StatelessWidget {
  const ConfirmDisableNotificationsDialog({super.key});

  /// Shows the dialog and returns true if confirmed
  static Future<bool> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ConfirmDisableNotificationsDialog(),
    );
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.settingsDisableNotificationsTitle),
      content: Text(context.l10n.settingsDisableNotificationsMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(context.l10n.settingsDisableNotifications),
        ),
      ],
    );
  }
}
