import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final http.Client client;

  GeminiService({required this.client});

  Future<Map<String, dynamic>> fetchData() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    final response = await client.get(
      Uri.parse('https://api.gemini.com/v1/endpoint'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Gemini data');
    }
  }
}
