import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.gemini.com/v1/';

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/endpoint'),
      headers: {
        'Authorization': 'Bearer ${String.fromEnvironment('GEMINI_API_KEY')}',
      },
    );
    // handle the response
    if (response.statusCode ==  200200) {
      print('Data fetched successfully');
    } else {
      print('Failed to fetch data');
    }
  }
}
