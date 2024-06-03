import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import '../lib/weather_service.dart';
import 'weather_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('WeatherService', () {
    final mockClient = MockClient();
    final weatherService = WeatherService(client: mockClient);

    test('should return weather data', () async {
      final response = {
        "location": {
          "name": "Tokyo",
          "region": "",
          "country": "Japan",
          "lat": 35.69,
          "lon": 139.69,
        },
        "current": {
          "temp_c": 20.0,
          "condition": {
            "text": "Clear",
            "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
          },
        },
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(json.encode(response), 200),
      );

      final result = await weatherService.getWeather(35.6895, 139.6917);

      expect(result, isNotNull);
      expect(result['current']['temp_c'], 20.0);
      expect(result['current']['condition']['text'], 'Clear');
    });
  });
}
