import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiChatService {
  static const String systemPrompt = """
أنت مساعد مختص في الجيم والتغذية.
- أجب بالعربية وبأسلوب واضح ومختصر.
- اسأل أسئلة توضيحية إذا ناقص معلومات.
- امنع النصائح الطبية/الأدوية/الهرمونات.
""";

  final List<Map<String, dynamic>> _history = [];

  Future<String> send(String userMessage) async {
    final apiKey = dotenv.env['AIzaSyBKVcdzSKKAK7dNdhkedW8c6TtrgL6vlX4']; // اقرأه هون
    if (apiKey == null || apiKey.isEmpty) {
      return "مفتاح GEMINI_API_KEY غير موجود. تأكد من ملف .env وassets.";
    }

    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
    );

    _history.add({
      "role": "user",
      "parts": [{"text": userMessage}]
    });

    final body = {
      "systemInstruction": {
        "parts": [{"text": systemPrompt}]
      },
      "contents": _history,
      "generationConfig": {"temperature": 0.6, "maxOutputTokens": 800}
    };

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      return "خطأ Gemini: ${res.statusCode}\n${res.body}";
    }

    final data = jsonDecode(res.body);
    final reply = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "ما قدرت أطلع رد.";

    _history.add({
      "role": "model",
      "parts": [{"text": reply}]
    });

    return reply;
  }

  void clear() => _history.clear();
}