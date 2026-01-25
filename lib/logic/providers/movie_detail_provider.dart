import 'package:flutter/material.dart';
import 'package:film_app/data/models/movie_details.dart';
import 'package:film_app/data/services/movie_service.dart';

class MovieDetailProvider extends ChangeNotifier {
  final MovieService _service = MovieService();

  MovieDetails? _movie;
  bool _isLoading = false;
  String? _error;

  MovieDetails? get movie => _movie;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMovie(int movieId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _movie = await _service.getMovieDetails(movieId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
