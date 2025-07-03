class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

factory Movie.fromJson(Map<String, dynamic> json) {
  return Movie(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    overview: json['overview'] ?? '',
    posterPath: json['poster_path'] ?? '',
    backdropPath: json['backdrop_path'],
    voteAverage: (json['vote_average'] ?? 0).toDouble(),
    releaseDate: json['release_date'] ?? '',
  );
}

  String get fullPosterPath => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get fullBackdropPath => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w500$backdropPath'
      : '';
}

