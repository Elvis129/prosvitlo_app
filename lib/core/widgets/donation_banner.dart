import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../extensions/localizations_extension.dart';

/// Donation banner widget displayed on Settings and About screens
class DonationBanner extends StatelessWidget {
  final VoidCallback onTap;

  const DonationBanner({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background image
            Image.asset(
              'assets/image/donat_mono.jpeg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            // Gradient overlay for better readability
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.8),
                    Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Center(
                child: AutoSizeText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  context.l10n.donationBannerSubtitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.95),
                    shadows: [
                      Shadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withValues(alpha: 0.5),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.coffee,
                          color: Theme.of(context).colorScheme.error,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AutoSizeText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          context.l10n.donationBannerTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                shadows: [
                                  Shadow(
                                    color: Theme.of(context).colorScheme.surface
                                        .withValues(alpha: 0.5),
                                    offset: const Offset(0, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.9),
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
