import 'dart:developer' as prefix0;

import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  SimpleLogPrinter(this.className);
  static int counter = 0;
  final String className;

  @override
  List<String> log(LogEvent event) {
    prefix0.log(
      event.message.toString(),
      time: DateTime.now(),
      level: _dartLogLevel(event.level),
      name: className,
      error: event.error,
      sequenceNumber: counter += 1,
    );
    return <String>[];
  }

  /// Map a logger [Level] to a `dart:developer` log level.
  ///
  /// Works off [Level.value] instead of matching enum cases so that the
  /// deprecated aliases (`verbose`, `wtf`, `nothing`) keep working.
  int _dartLogLevel(Level level) {
    final int value = level.value;
    if (value <= 1000) {
      return 0; // all / verbose / trace
    }
    if (value == 2000) {
      return 500; // debug
    }
    if (value == 3000) {
      return 0; // info
    }
    if (value == 4000) {
      return 1500; // warning
    }
    return 2000; // error / wtf / fatal / nothing / off
  }
}

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}
