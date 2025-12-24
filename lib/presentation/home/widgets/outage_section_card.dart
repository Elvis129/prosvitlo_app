import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/outage_info_model.dart';

/// Universal widget for displaying outage sections (emergency, planned, or schedule)
class OutageSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<OutageInfoModel> outages;
  final bool showActiveBadge;

  const OutageSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.outages,
    this.showActiveBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outages.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: AppSpacing.md),

        // Section header
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AppSpacing.sm),
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Outages list
        ...outages.map(
          (outage) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _buildOutageCard(outage),
          ),
        ),
      ],
    );
  }

  Widget _buildOutageCard(OutageInfoModel outage) {
    return Builder(
      builder: (context) {
        final isActive = showActiveBadge && outages.indexOf(outage) == 0;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isActive ? 0.1 : 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? color : color.withValues(alpha: 0.3),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isActive) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        context.l10n.homeActive,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Text(
                      outage.remName,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: isActive ? color : AppColors.slateGray,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    outage.getTimeRange(),
                    style: AppTextStyles.body.copyWith(
                      fontWeight: isActive
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (outage.workType.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(outage.workType, style: AppTextStyles.caption),
              ],
            ],
          ),
        );
      },
    );
  }
}
