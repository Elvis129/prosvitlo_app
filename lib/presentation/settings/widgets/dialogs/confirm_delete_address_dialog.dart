import 'package:flutter/material.dart';
import '../../../../core/extensions/localizations_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Dialog to confirm address deletion
class ConfirmDeleteAddressDialog extends StatelessWidget {
  final String addressName;

  const ConfirmDeleteAddressDialog({super.key, required this.addressName});

  /// Shows the dialog and returns true if confirmed
  static Future<bool> show(BuildContext context, String addressName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          ConfirmDeleteAddressDialog(addressName: addressName),
    );
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.settingsDeleteAddressTitle),
      content: Text(context.l10n.settingsDeleteAddressMessage(addressName)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(context.l10n.delete),
        ),
      ],
    );
  }
}
