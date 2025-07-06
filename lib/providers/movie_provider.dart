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
    title: 'BTS: Yet to Come',
    overview: 'Únase a RM, Jin, SUGA, j-hope, Jimin, V y Jung Kook en este corte cinematográfico especial, reeditado y remezclado para la pantalla grande. Mire nuevos ángulos de primer plano y una vista completamente nueva de todo el concierto de BTS Yet To Come en Busan. Con canciones exitosas de toda la carrera del grupo, incluidas "Dynamite", "Butter" e "IDOL", además del primer concierto de "Run BTS" del último álbum del grupo, Proof.',
    posterPath: 'https://www.themoviedb.org/t/p/w1280/f3L3nKsx5wGr620c1QQKTk6h0JX.jpg',
    voteAverage: 8.6,
    releaseDate: '2023-02-01',
  ),
  Movie(
    id: 2,
    title: 'Squid Game: Season 3',
    overview: 'Se centra en las consecuencias de la fallida rebelión de Gi-hun y la traición del Líder (In-ho). La temporada explora cómo Gi-hun lidia con la culpa y el fracaso mientras se enfrenta a juegos cada vez más letales.',
    posterPath: 'https://www.themoviedb.org/t/p/w1280/74qMRUy0lwkBBi39vsQVerIDkHj.jpg',
    voteAverage: 8.9,
    releaseDate: '2025-06-27',
  ),
  
  Movie(
    id: 2,
    title: 'MEGAN 2.0',
    overview: 'Con el futuro de la existencia humana en juego, Gemma se da cuenta de que la única opción es resucitar a M3GAN y darle unas cuantas mejoras, haciéndola más rápida, más fuerte y más letal.',
    posterPath: 'https://www.themoviedb.org/t/p/w1280/w8llBJfNIJoQY9UV8p1eOBTyEjP.jpg',
    voteAverage: 6.3,
    releaseDate: '2025-06-26',
  ),
  
  Movie(
    id: 2,
    title: 'Dora en busca del Sol Dorado',
    overview: 'Dora, Diego y Botas se unen a Naiya y Sonny en una emocionante búsqueda para encontrar el antiguo tesoro inca: el Sol Dorado.',
    posterPath: 'https://www.themoviedb.org/t/p/w1280/sVLSOnGfNXj7VVGBgOz5cNa0lDz.jpg',
    voteAverage: 7.3,
    releaseDate: '2025-07-02',
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
