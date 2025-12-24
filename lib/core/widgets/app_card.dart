import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

/// Reusable card widget with optional tap interaction
/// Uses theme configuration for consistent styling
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    final borderRadius =
        (cardTheme.shape as RoundedRectangleBorder?)?.borderRadius
            as BorderRadius? ??
        BorderRadius.circular(16);

    return Card(
      color: color,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}
