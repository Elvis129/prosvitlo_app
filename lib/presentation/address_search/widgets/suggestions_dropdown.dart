import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';

/// Dropdown widget for displaying suggestions list
class SuggestionsDropdown extends StatelessWidget {
  final List<String> items;
  final Function(String) onSelect;

  const SuggestionsDropdown({
    super.key,
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.only(top: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: const BoxConstraints(maxHeight: 250),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              dense: true,
              title: Text(item, style: AppTextStyles.body),
              onTap: () => onSelect(item),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.slateGray400,
              ),
            );
          },
        ),
      ),
    );
  }
}
