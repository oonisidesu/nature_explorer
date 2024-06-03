import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final http.Client client;

  WeatherService({required this.client});

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final apiKey = dotenv.env['WEATHER_API_KEY'];
    final url =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$lon';
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
