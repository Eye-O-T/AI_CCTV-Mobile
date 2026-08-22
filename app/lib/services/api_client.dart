import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
  });

  Future<http.Response> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    return http.get(uri);
  }
}