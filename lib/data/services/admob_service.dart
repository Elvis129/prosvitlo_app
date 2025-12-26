import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Service for managing AdMob initialization and ad unit IDs
///
/// IMPORTANT: When you get real AdMob keys:
/// 1. Replace test App IDs in AndroidManifest.xml and Info.plist
/// 2. Replace test Ad Unit IDs in this file
class AdMobService {
  static AdMobService? _instance;
  static AdMobService get instance => _instance ??= AdMobService._();

  AdMobService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initialize AdMob SDK
  /// Call at app startup
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  /// Production Banner Ad Unit ID for Android
  static const String _androidBannerAdUnitId =
      'ca-app-pub-9919446828040983/5747494503';

  /// Production Banner Ad Unit ID for iOS
  static const String _iosBannerAdUnitId =
      'ca-app-pub-9919446828040983/5747494503';

  /// Get Banner Ad Unit ID for current platform
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _androidBannerAdUnitId;
    } else if (Platform.isIOS) {
      return _iosBannerAdUnitId;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  /// Create Banner Ad
  ///
  /// [onAdLoaded] - callback on successful load
  /// [onAdFailedToLoad] - callback on load error
  BannerAd createBannerAd({
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner, // 320x50
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  /// Dispose resources
  void dispose() {
    _isInitialized = false;
  }
}
