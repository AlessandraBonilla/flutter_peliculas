import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/movie_services.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();
  List<Movie> _popularMovies = [];
  List<Movie> _searchResults = [];
final List<Movie> _recommendedMovies = [
  Movie(
    id: 1,
    title: 'Pelicula 1',
    overview: 'Descripción 1',
    posterPath: '/nBNZadXqJSdt05SHLqgT0HuC5Gm.jpg',
    voteAverage: 8.5,
    releaseDate: '2022-01-01',
  ),
  Movie(
    id: 2,
    title: 'Pelicula 2',
    overview: 'Descripción 2',
    posterPath: '/xBKGJQsAIeweesB79KC89FpBrVr.jpg',
    voteAverage: 7.9,
    releaseDate: '2021-12-15',
  ),
];
  bool _isLoading = false;
  String _error = '';

  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get recommendedMovies => _recommendedMovies;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _popularMovies = await _movieService.getPopularMovies();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _movieService.searchMovies(query);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
