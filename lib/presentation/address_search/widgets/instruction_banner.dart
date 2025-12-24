import 'package:flutter/material.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';

/// Instruction banner widget for address selection
class InstructionBanner extends StatelessWidget {
  const InstructionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryYellow.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primaryBlue),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              context.l10n.addressSearchInstruction(
                context.l10n.addressFieldCity.toLowerCase(),
                context.l10n.addressFieldStreet.toLowerCase(),
                context.l10n.addressFieldHouse.toLowerCase(),
              ),
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
