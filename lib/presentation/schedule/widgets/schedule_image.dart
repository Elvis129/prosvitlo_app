import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/localizations_extension.dart';

/// Cached network image for schedule with fixed height to prevent jumping
class ScheduleImage extends StatelessWidget {
  final String imageUrl;

  const ScheduleImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      width: double.infinity,
      placeholder: (context, url) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorWidget: (context, url, error) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  size: 48,
                  color: isDark
                      ? AppColors.slateGray500
                      : AppColors.slateGray400,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.errorLoadingImage,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
