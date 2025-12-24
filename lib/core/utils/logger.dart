class AppLogger {
  static const String _tag = '[SwitchTracker]';

  static void debug(String message) {
    // Em produção, usar um serviço real de logging (Sentry, Firebase, etc)
    // ignore: avoid_print
    print('$_tag [DEBUG] $message');
  }

  static void info(String message) {
    // ignore: avoid_print
    print('$_tag [INFO] $message');
  }

  static void warning(String message) {
    // ignore: avoid_print
    print('$_tag [WARNING] $message');
  }

  static void error(String message, [StackTrace? stackTrace]) {
    // ignore: avoid_print
    print('$_tag [ERROR] $message');
    if (stackTrace != null) {
      // ignore: avoid_print
      print(stackTrace);
    }
  }
}