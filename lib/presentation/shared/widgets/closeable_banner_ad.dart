import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:prosvitlo_app/data/services/admob_service.dart';

/// Closeable banner ad widget
///
/// Displays an AdMob banner above bottom navigation with a close button.
/// After closing, the banner disappears and won't show again until next app launch.
class CloseableBannerAd extends StatefulWidget {
  const CloseableBannerAd({super.key});

  @override
  State<CloseableBannerAd> createState() => _CloseableBannerAdState();
}

class _CloseableBannerAdState extends State<CloseableBannerAd> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdClosed = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    // Check if AdMob is initialized
    if (!AdMobService.instance.isInitialized) {
      return;
    }

    _bannerAd = AdMobService.instance.createBannerAd(
      onAdLoaded: (ad) {
        setState(() {
          _isAdLoaded = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        setState(() {
          _isAdLoaded = false;
        });
      },
    );

    _bannerAd?.load();
  }

  void _closeAd() {
    setState(() {
      _isAdClosed = true;
    });
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show if closed or not loaded
    if (_isAdClosed || !_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Banner
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
            // Close button
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _closeAd,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.surface,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
