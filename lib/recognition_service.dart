import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class RecognitionService {
  final String apiKey;

  RecognitionService({required this.apiKey});

  Future<String> recognizeImage(File image) async {
    final model = GenerativeModel(
      model: "gemini-1.5-flash-latest",
      apiKey: apiKey,
    );

    final imageBytes = await image.readAsBytes();
    final response = await model.generateContent([
      Content.text("What's in this photo?"),
      Content.data("image/png", imageBytes),
    ]);

    return response.text ?? "No recognition result.";
  }
}
