import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecognitionScreen extends StatefulWidget {
  @override
  _RecognitionScreenState createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  File? _image;
  String _recognitionResult = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _recognizeImage();
    }
  }

  Future<void> _recognizeImage() async {
    if (_image == null) {
      setState(() {
        _recognitionResult = 'No image selected.';
      });
      return;
    }

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY']!;
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final imageBytes = await _image!.readAsBytes();
      final content = [
        Content.text('What is in this photo?'),
        Content.data('image/png', imageBytes),
      ];

      final response = await model.generateContent(content);

      setState(() {
        _recognitionResult = response.text ?? 'No recognition result.';
      });
    } catch (e) {
      setState(() {
        _recognitionResult = 'Exception: Failed to recognize image: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Recognition'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_image != null)
                Image.file(_image!)
              else
                Text('No image selected.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image from Gallery'),
              ),
              SizedBox(height: 20),
              Text(_recognitionResult),
            ],
          ),
        ),
      ),
    );
  }
}
