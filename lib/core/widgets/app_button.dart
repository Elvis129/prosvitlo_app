import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

/// Reusable button widget that follows app theme
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = _buildContent(context);
    final VoidCallback? action = isLoading ? null : onPressed;

    final Widget button = isOutlined
        ? OutlinedButton(onPressed: action, child: buttonChild)
        : ElevatedButton(onPressed: action, child: buttonChild);

    return SizedBox(width: width, child: button);
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      final colorScheme = Theme.of(context).colorScheme;
      final indicatorColor = isOutlined
          ? colorScheme.primary
          : colorScheme.onPrimary;

      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: indicatorColor),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
