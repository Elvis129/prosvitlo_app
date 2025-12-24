import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import 'suggestions_dropdown.dart';

/// Generic address field widget for city/street/house selection
class AddressField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final IconData icon;
  final String label;
  final String hint;
  final String disabledHint;
  final bool enabled;
  final bool required;
  final bool showDropdown;
  final List<String> suggestions;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSelect;
  final VoidCallback? onClear;

  const AddressField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.icon,
    required this.label,
    required this.hint,
    required this.disabledHint,
    this.enabled = true,
    this.required = false,
    this.showDropdown = false,
    this.suggestions = const [],
    required this.onChanged,
    required this.onSelect,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: enabled ? null : AppColors.slateGray400,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.heading3.copyWith(
                color: enabled ? null : AppColors.slateGray400,
              ),
            ),
            if (required)
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
          hint: enabled ? hint : disabledHint,
          enabled: enabled,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
              : null,
          onChanged: onChanged,
        ),

        // Suggestions dropdown
        if (showDropdown && suggestions.isNotEmpty)
          SuggestionsDropdown(items: suggestions, onSelect: onSelect),
      ],
    );
  }
}
