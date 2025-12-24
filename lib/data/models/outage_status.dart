/// Power outage status
enum OutageStatus {
  /// Power is on
  on,

  /// Power is off
  off,

  /// Status is unknown
  unknown;

  /// Converts a string value to OutageStatus
  /// Returns [unknown] if value is null or not recognized
  /// Accepts: 'on', 'active' -> on | 'off', 'inactive' -> off
  static OutageStatus fromString(String? value) {
    if (value == null) return OutageStatus.unknown;
    switch (value.toLowerCase()) {
      case 'on':
      case 'active':
        return OutageStatus.on;
      case 'off':
      case 'inactive':
        return OutageStatus.off;
      default:
        return OutageStatus.unknown;
    }
  }

  /// Converts OutageStatus to string for JSON serialization
  String toJson() => name;
}
