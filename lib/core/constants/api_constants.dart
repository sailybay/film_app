import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final apiKey = dotenv.env['FILM_API_KEY'] ?? '';
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const language = 'ru-RU';

  static const imageBaseUrl = 'https://image.tmdb.org/t/p/';
}
