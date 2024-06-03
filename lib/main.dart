import 'package:geolocator/geolocator.dart';
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
    final envPath = 'assets/.env';
    final envString = await rootBundle.loadString(envPath);
    print('Env file content: $envString');

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
  bool isFetchingLocation = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        isFetchingLocation = false;
        errorMessage = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          isFetchingLocation = false;
          errorMessage = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isFetchingLocation = false;
        errorMessage =
            'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    _getWeather();
    _startLocationUpdates();
  }

  void _getWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        weatherData =
            weatherService.getWeather(position.latitude, position.longitude);
        isFetchingLocation = false;
      });
    } catch (e) {
      setState(() {
        isFetchingLocation = false;
        errorMessage = 'Failed to get location';
      });
    }
  }

  void _startLocationUpdates() {
    Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      setState(() {
        weatherData =
            weatherService.getWeather(position.latitude, position.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Information'),
      ),
      body: isFetchingLocation
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : FutureBuilder<Map<String, dynamic>>(
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
