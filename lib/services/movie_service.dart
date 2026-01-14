import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:film_app/models/movie.dart';

class TMDbService {
  // ВАЖНО: Замените на ваш API ключ из TMDb!
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _language = 'ru-RU';

  // Популярные фильмы
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/movie/popular?api_key=$_apiKey&language=$_language&page=$page',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Топ рейтинговые фильмы
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/movie/top_rated?api_key=$_apiKey&language=$_language&page=$page',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    }
    throw Exception('Ошибка загрузки');
  }

  // Новинки кино
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=$_language&page=$page',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    }
    throw Exception('Ошибка загрузки');
  }

  // Детали фильма
  Future<MovieDetails> getMovieDetails(int movieId) async {
    final url = Uri.parse(
      '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=$_language',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetails.fromJson(data);
    }
    throw Exception('Ошибка загрузки деталей');
  }

  // Поиск фильмов
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/search/movie?api_key=$_apiKey&language=$_language&query=$query&page=$page',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    }
    throw Exception('Ошибка поиска');
  }
}
