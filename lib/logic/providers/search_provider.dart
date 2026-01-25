import 'package:flutter/material.dart';
import 'package:film_app/data/models/movie.dart';
import 'package:film_app/data/services/movie_service.dart';

class SearchProvider extends ChangeNotifier {
  final MovieService _service = MovieService();

  List<Movie> _results = [];
  bool _isLoading = false;
  String? _error;

  List<Movie> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _results = await _service.searchMovies(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _results = [];
    notifyListeners();
  }
}
