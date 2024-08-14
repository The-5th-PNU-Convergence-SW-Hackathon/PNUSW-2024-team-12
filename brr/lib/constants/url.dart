import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
}

class Urls {
  static final String apiUrl = '${BaseUrl.baseUrl}/';
}
