import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/extensions/localizations_extension.dart';

/// Widget displayed when there are no saved addresses
class EmptyAddressesCard extends StatelessWidget {
  const EmptyAddressesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Icon(
                Icons.location_off,
                size: 48,
                color: AppColors.slateGray,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.l10n.homeNoAddressesTitle,
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
