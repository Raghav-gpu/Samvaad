import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  Future<String> getGeminiResponse(String prompt) async {
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null) {
      return "Error: API Key not found. Check your .env file.";
    }

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("Full JSON Response: $jsonData"); // Print for debugging

        final candidates = jsonData['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map<String, dynamic>?;
          if (content != null && content.isNotEmpty) {
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final text = parts[0]['text'] as String?;
              if (text != null) {
                return text;
              }
            }
          }
        }
        return "No response: Could not parse JSON"; // More descriptive message
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      print('Error: $e');
      return "Error: $e";
    }
  }
}
