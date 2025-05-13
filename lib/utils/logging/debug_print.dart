import 'package:flutter/foundation.dart';

/// This function wraps the standard `print` function to only output messages
/// when the app is running in debug mode. It helps
/// prevent unnecessary log messages from appearing in production builds.
///
/// Use normal print if you want to print in all mode
void printDebug(Object? object) {
  if (kDebugMode) print(object);
}
