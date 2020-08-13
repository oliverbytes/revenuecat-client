import 'package:logger/logger.dart';

Logger initLogger(final String className) {
  return Logger(printer: MyLogPrinter(className));
}

class MyLogPrinter extends LogPrinter {
  final String className;
  MyLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    print(color('$emoji $className - ${event.message}'));
    return [];
  }
}
