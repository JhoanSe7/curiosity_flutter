import 'package:logging/logging.dart';

class Logging {
  static void run() async {
    Logger.root.level = Level.ALL;

    Logger.root.onRecord.listen((rec) async {
      print('${rec.level.name}: ${rec.message}');
    });
  }
}
