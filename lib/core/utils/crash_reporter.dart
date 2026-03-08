import 'dart:async';
import 'package:flutter/foundation.dart';

/// Crash reporting service.
///
/// To enable Sentry:
/// 1. Add `sentry_flutter: ^8.12.0` to pubspec.yaml
/// 2. Call `CrashReporter.init('YOUR_SENTRY_DSN')` in main.dart
/// 3. Wrap runApp with `CrashReporter.guard()`
class CrashReporter {
  static bool _initialized = false;

  /// Initialize crash reporting. No-op in debug mode.
  static Future<void> init(String dsn) async {
    if (kDebugMode) return;
    // TODO: await SentryFlutter.init((options) {
    //   options.dsn = dsn;
    //   options.tracesSampleRate = 0.2;
    //   options.environment = kReleaseMode ? 'production' : 'staging';
    // });
    _initialized = true;
  }

  /// Reports an exception to crash reporting service.
  static Future<void> report(
    Object error,
    StackTrace stackTrace, {
    String? context,
  }) async {
    if (kDebugMode) {
      debugPrint('CrashReporter: $error\n$stackTrace');
      return;
    }
    if (!_initialized) return;
    // TODO: await Sentry.captureException(error, stackTrace: stackTrace);
  }

  /// Wraps app startup to catch uncaught exceptions.
  static Future<void> guard(Future<void> Function() appRunner) async {
    await runZonedGuarded(
      appRunner,
      (error, stack) => report(error, stack, context: 'uncaught'),
    );
  }
}
