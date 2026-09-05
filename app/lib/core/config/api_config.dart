class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static String mediaUrl(String path) {
    if (path.startsWith('/')) {
      return '$baseUrl$path';
    }

    return '$baseUrl/$path';
  }
}
