import 'dart:developer';
import 'package:flutter/foundation.dart';

// White text
void logInfo(var msg) {
  if (kDebugMode) {
    log('\x1B[37m${msg.toString()}\x1B[0m');
  }
}

// Green text
void logSuccess(var msg) {
  if (kDebugMode) {
    log('\x1B[32m${msg.toString()}\x1B[0m');
  }
}

// Yellow text
void logWarning(var msg) {
  if (kDebugMode) {
    log('\x1B[33m${msg.toString()}\x1B[0m');
  }
}

// Red text
void logError(var msg) {
  if (kDebugMode) {
    log('\x1B[31m ERROR: ${msg.toString()}\x1B[0m');
  }
}
