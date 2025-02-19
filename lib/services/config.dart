import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
}
