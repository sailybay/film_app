import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:film_app/data/models/movie.dart';
import 'package:film_app/core/constants/api_constants.dart';
import 'package:film_app/data/models/movie_details.dart';

class MovieService {
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/movie/popular?api_key=${ApiConstants.apiKey}&language=${ApiConstants.language}&page=$page',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    }
    throw Exception('Ошибка загрузки');
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/movie/top_rated?api_key=${ApiConstants.apiKey}&language=${ApiConstants.language}&page=$page',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    }
    throw Exception('Ошибка загрузки');
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/movie/now_playing?api_key=${ApiConstants.apiKey}&language=${ApiConstants.language}&page=$page',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    }
    throw Exception('Ошибка загрузки');
  }

  Future<MovieDetails> getMovieDetails(int movieId) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/movie/$movieId?api_key=${ApiConstants.apiKey}&language=${ApiConstants.language}',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetails.fromJson(data);
    }
    throw Exception('Ошибка загрузки деталей');
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/search/movie?api_key=${ApiConstants.apiKey}&language=${ApiConstants.language}&query=$query&page=$page',
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
