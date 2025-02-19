import 'package:bot/pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bot/theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
    fileName: ".env",
  ); // Load .env here, before runApp()

  print("DOTENV loaded: ${dotenv.env.isNotEmpty}"); // Check if loaded
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  print("API Key (first 5 chars): ${apiKey?.substring(0, 5)}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
      theme: AppTheme.darkTheme,
    );
  }
}
