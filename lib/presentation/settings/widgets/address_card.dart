import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/address_model.dart';
import '../models/address_action.dart';

/// Widget for displaying a single address card with edit/delete actions
class AddressCard extends StatelessWidget {
  final AddressModel address;
  final Function(AddressAction) onAction;

  const AddressCard({super.key, required this.address, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryYellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.name,
                  style: AppTextStyles.heading3.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  address.fullAddress,
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.addressQueue(address.queue),
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.slateGray,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<AddressAction>(
            onSelected: onAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: AddressAction.edit,
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 18),
                    const SizedBox(width: 8),
                    Text(context.l10n.edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: AddressAction.delete,
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 18, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.delete,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
