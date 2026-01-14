import 'package:flutter/material.dart';
import 'package:film_app/data/models/movie.dart';
import 'package:film_app/data/services/movie_service.dart';
import 'package:film_app/data/models/movie_details.dart';

class MovieProvider extends ChangeNotifier {
  final MovieService _service = MovieService();

  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _searchResults = [];

  bool _isLoading = false;
  String? _error;
  int _selectedTab = 0;

  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedTab => _selectedTab;

  List<Movie> get currentMovies {
    switch (_selectedTab) {
      case 0:
        return _popularMovies;
      case 1:
        return _topRatedMovies;
      case 2:
        return _nowPlayingMovies;
      default:
        return _popularMovies;
    }
  }

  void setTab(int index) {
    _selectedTab = index;
    notifyListeners();
    if (currentMovies.isEmpty) loadMovies();
  }

  Future<void> loadMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      switch (_selectedTab) {
        case 0:
          _popularMovies = await _service.getPopularMovies();
          break;
        case 1:
          _topRatedMovies = await _service.getTopRatedMovies();
          break;
        case 2:
          _nowPlayingMovies = await _service.getNowPlayingMovies();
          break;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<MovieDetails> getMovieDetails(int movieId) async {
    return await _service.getMovieDetails(movieId);
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _searchResults = await _service.searchMovies(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}
