import 'package:flutter/material.dart';
import 'package:film_app/data/models/movie.dart';
import 'package:film_app/data/services/movie_service.dart';

class MovieListProvider extends ChangeNotifier {
  final MovieService _service = MovieService();

  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];

  bool _isLoading = false;
  String? _error;
  int _selectedTab = 0;

  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
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
    if (_isLoading || currentMovies.isNotEmpty) return;

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
}
