import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'logger.dart';

/// This is the base service that all the services extends.
///
/// It contains the Logger package to print clear and readable logs.

abstract class BaseService {
  BaseService({String? title}) : _title = title {
    _log = getLogger(modelTitle);
  }
  final String? _title;
  Logger? _log;
  String get modelTitle => _title ?? runtimeType.toString();

  void logInfo(String message) {
    if (kReleaseMode) {
      return;
    }
    _log?.i(message);
  }

  void logWarning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kReleaseMode) {
      return;
    }
    _log?.w(message, error, stackTrace);
  }

  /// Log an error, if is in release mode then send it to crashlytics
  void logError(String message, dynamic error, [StackTrace? stackTrace]) {
    _log?.e(message, error, stackTrace);
  }

  void logWTF(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kReleaseMode) {
      return;
    }
    _log?.wtf(message, error, stackTrace);
  }

  void dispose() {
    logInfo('dispose');
  }
}
