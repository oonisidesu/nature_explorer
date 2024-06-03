import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final http.Client client;

  WeatherService({required this.client});

  Future<Map<String, dynamic>> getWeather(
      double latitude, double longitude) async {
    final apiKey = dotenv.env['WEATHER_API_KEY'];
    final response = await client.get(
      Uri.parse(
          'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$latitude,$longitude'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
