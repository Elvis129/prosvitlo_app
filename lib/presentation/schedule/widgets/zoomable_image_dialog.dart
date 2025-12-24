import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';

/// Zoomable image viewer dialog
class ZoomableImageDialog extends StatelessWidget {
  final String imageUrl;

  const ZoomableImageDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.textDark,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Zoomable image
          Hero(
            tag: 'schedule_$imageUrl',
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textLight,
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 64,
                        color: isDark
                            ? AppColors.slateGray500
                            : AppColors.slateGray300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Close button
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: isDark ? AppColors.textLight : AppColors.textLight,
                size: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows the zoomable image dialog
  static void show(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => ZoomableImageDialog(imageUrl: imageUrl),
    );
  }
}
