import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> load(String flavor) async {
    await dotenv.load(fileName: 'assets/config/.env.$flavor');
  }
}
