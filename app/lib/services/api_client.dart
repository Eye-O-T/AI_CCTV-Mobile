import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<http.Response> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    return http.get(uri);
  }

  Future<http.Response> postJson(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');

    return http.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
