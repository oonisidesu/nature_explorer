import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'weather_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Loading .env file...");
  try {
    // Flutterのアセットから .env ファイルを読み込む
    final envPath = 'assets/.env';
    final envString = await rootBundle.loadString(envPath);
    print('Env file content: $envString');

    // テンポラリディレクトリに書き出す
    final tempDir = Directory.systemTemp;
    final tempFilePath = path.join(tempDir.path, '.env');
    final tempFile = File(tempFilePath);
    await tempFile.writeAsString(envString);
    print('Temp env file path: $tempFilePath');

    await dotenv.load(fileName: tempFilePath);
    print("Loaded .env file successfully");
    print('WEATHER_API_KEY: ${dotenv.env['WEATHER_API_KEY']}');
    print('GEMINI_API_KEY: ${dotenv.env['GEMINI_API_KEY']}');

    runApp(MyApp());
  } catch (e) {
    print("Could not load .env file: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService(client: http.Client());
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = weatherService.getWeather(35.6895, 139.6917); // 東京の緯度と経度
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Information'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final weather = snapshot.data!['current'];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Temperature: ${weather['temp_c']}°C'),
                  Text('Condition: ${weather['condition']['text']}'),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
