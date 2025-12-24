import 'package:flutter/material.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_text_field.dart';

/// Name field widget with suggestions for address naming
class NameField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String> onChanged;

  const NameField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onChanged,
  });

  // Get localized name suggestions
  List<String> _getSuggestions(BuildContext context) => [
    context.l10n.addressSuggestionHome,
    context.l10n.addressSuggestionWork,
    context.l10n.addressSuggestionParents,
    context.l10n.addressSuggestionSchool,
    context.l10n.addressSuggestionGrandma,
    context.l10n.addressSuggestionOffice,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            const Icon(Icons.label, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text(context.l10n.addressNameTitle, style: AppTextStyles.heading3),
            Text(
              ' *',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Text field
        AppTextField(
          controller: controller,
          focusNode: focusNode,
          hint: context.l10n.addressNameHint,
          enabled: true,
          prefixIcon: const Icon(Icons.edit),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.text = context.l10n.addressNameDefault;
                    onChanged(context.l10n.addressNameDefault);
                  },
                )
              : null,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Suggestions label
        Text(
          context.l10n.addressNameSuggestions,
          style: AppTextStyles.small.copyWith(
            color: AppColors.slateGray,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Suggestion chips
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: _getSuggestions(context).map((suggestion) {
            return InkWell(
              onTap: () {
                // Remove emoji and set clean name
                final cleanName = suggestion
                    .replaceAll(RegExp(r'[^\w\s\u0400-\u04FF]'), '')
                    .trim();
                controller.text = cleanName;
                onChanged(cleanName);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                      : AppColors.slateGray100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  suggestion,
                  style: AppTextStyles.small.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
