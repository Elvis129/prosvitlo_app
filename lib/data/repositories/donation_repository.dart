import 'package:shared_preferences/shared_preferences.dart';
import '../models/donation_info_model.dart';
import '../services/api_client.dart';
import '../services/log_color.dart';

/// Repository for donation information with 24-hour caching
class DonationRepository {
  final ApiClient _apiClient;

  static const String _donationCacheKey = 'cached_donation_url';
  static const String _donationCardCacheKey = 'cached_donation_card';
  static const String _donationCacheTimeKey = 'donation_cache_time';
  static const Duration _cacheDuration = Duration(hours: 24);

  DonationRepository(this._apiClient);

  /// Get donation information with caching
  Future<DonationInfoModel?> getDonationInfo() async {
    // Try to load from cache first
    final cachedInfo = await _loadFromCache();
    if (cachedInfo != null) {
      return cachedInfo;
    }

    // Load from API if cache is expired or empty
    try {
      final response = await _apiClient.get('/donation');

      final jarUrl = response['jar_url'] as String?;
      final cardNumber = response['card_number'] as String?;

      if (jarUrl != null && jarUrl.isNotEmpty) {
        final donationInfo = DonationInfoModel(
          url: jarUrl,
          cardNumber: cardNumber,
        );

        // Save to cache
        await _saveToCache(donationInfo);

        return donationInfo;
      }

      return null;
    } catch (e) {
      logError('[DonationRepository] Failed to load donation info: $e');
      return null;
    }
  }

  /// Load donation info from cache
  Future<DonationInfoModel?> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedUrl = prefs.getString(_donationCacheKey);
      final cachedCard = prefs.getString(_donationCardCacheKey);
      final cacheTimeStr = prefs.getString(_donationCacheTimeKey);

      if (cachedUrl != null && cacheTimeStr != null) {
        final cacheTime = DateTime.parse(cacheTimeStr);
        final age = DateTime.now().difference(cacheTime);

        if (age < _cacheDuration) {
          logInfo('[DonationRepository] Loaded donation info from cache');
          return DonationInfoModel(url: cachedUrl, cardNumber: cachedCard);
        }
      }

      return null;
    } catch (e) {
      logWarning('[DonationRepository] Error loading from cache: $e');
      return null;
    }
  }

  /// Save donation info to cache
  Future<void> _saveToCache(DonationInfoModel info) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_donationCacheKey, info.url);
      if (info.cardNumber != null) {
        await prefs.setString(_donationCardCacheKey, info.cardNumber!);
      }
      await prefs.setString(
        _donationCacheTimeKey,
        DateTime.now().toIso8601String(),
      );
      logInfo('[DonationRepository] Saved donation info to cache');
    } catch (e) {
      logWarning('[DonationRepository] Error saving to cache: $e');
    }
  }
}
