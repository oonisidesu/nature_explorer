// lib/post_service.dart
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class PostService {
  static Future<void> uploadPost(File image, String comment) async {
    final request = http.MultipartRequest('POST', Uri.parse('YOUR_SERVER_URL'));
    request.fields['comment'] = comment;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload post');
    }
  }
}
