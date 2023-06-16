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
      level: () {
        switch (event.level) {
          case Level.verbose:
            return 0;
          case Level.debug:
            return 500;
          case Level.info:
            return 0;
          case Level.warning:
            return 1500;
          case Level.error:
            return 2000;
          case Level.wtf:
          case Level.nothing:
            return 2000;
        }
      }(),
      name: className,
      error: event.error,
      sequenceNumber: counter += 1,
    );
    return <String>[];
  }
}

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}
