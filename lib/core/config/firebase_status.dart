/// Firebase initialization status
enum FirebaseStatus {
  /// Firebase successfully initialized and ready to use
  ready,

  /// Firebase unavailable (initialization error or not supported)
  unavailable;

  /// Whether Firebase is available
  bool get isAvailable => this == FirebaseStatus.ready;

  /// Whether Firebase is unavailable
  bool get isUnavailable => this == FirebaseStatus.unavailable;
}
