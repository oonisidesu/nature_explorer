import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'weather_screen.dart';
import 'recognition_screen.dart';
import 'post_screen.dart';
import 'contest_screen.dart';
import 'stamp_rally_screen.dart';

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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Nature Explorer'),
        ),
        body: Center(
          child: Text('API Key is not set. Please check your .env file.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Nature Explorer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Weather'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Recognition'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecognitionScreen(apiKey: apiKey)),
                );
              },
            ),
            ElevatedButton(
              child: Text('Post'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostScreen(apiKey: apiKey)),
                );
              },
            ),
            ElevatedButton(
              child: Text('Contest'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContestScreen(apiKey: apiKey)),
                );
              },
            ),
            ElevatedButton(
              child: Text('Stamp Rally'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StampRallyScreen(apiKey: apiKey)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
