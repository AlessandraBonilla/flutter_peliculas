import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  final String _apiKey = '2b1e726322f9be05cdd520723e35bfb8'; // Reemplaza con tu API key de TMDb, HECHO
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=es-MX&page=1'), //HECHO
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final List<dynamic> results = decodedData['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&language=es-MX&query=$query'),
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final List<dynamic> results = decodedData['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}