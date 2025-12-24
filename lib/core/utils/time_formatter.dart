import 'package:intl/intl.dart';

/// Formats DateTime to human-readable relative time or absolute date
class TimeFormatter {
  TimeFormatter._();

  /// Formats time as relative (e.g., "5 min ago") or absolute date
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    // Handle negative difference (future time) or very old dates
    if (diff.isNegative || diff.inDays >= 7) {
      return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
    }

    if (diff.inMinutes < 1) return 'Щойно';
    if (diff.inMinutes < 60) return '${diff.inMinutes} хв тому';
    if (diff.inHours < 24) return '${diff.inHours} год тому';
    if (diff.inDays < 7) return '${diff.inDays} дн тому';

    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  /// Formats time as absolute date with time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  /// Formats time as short date
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  /// Formats time only
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}
