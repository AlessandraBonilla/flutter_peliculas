import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.fetchPopularMovies();
  }

  void _showRecommendedMovies(BuildContext context) {
    debugShowCheckedModeBanner: false;
    final recommendedMovies = Provider.of<MovieProvider>(context, listen: false).recommendedMovies;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF181818),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: recommendedMovies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final movie = recommendedMovies[index];
            return _MovieCard(movie: movie);
          },
        ),
      ),
    );
  }

  Widget _buildMovieGallery(MovieProvider movieProvider) {
    final movies = _isSearching ? movieProvider.searchResults : movieProvider.popularMovies;
    if (movies.isEmpty) {
      return const Center(child: Text('No hay películas', style: TextStyle(color: Colors.white70)));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _MovieCard(movie: movie);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        title: const Text('Películas', style: TextStyle(color: Color(0xFFFFC300))),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFFFC300)),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(movieProvider),
              );
            },
          ),
        ],
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFC300)))
          : movieProvider.error.isNotEmpty
              ? Center(child: Text('Error: ${movieProvider.error}', style: const TextStyle(color: Colors.redAccent)))
              : _buildMovieGallery(movieProvider),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC300),
        onPressed: () => _showRecommendedMovies(context),
        child: const Icon(Icons.movie_creation, color: Colors.black),
        tooltip: 'Películas recomendadas',
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final dynamic movie;
  const _MovieCard({required this.movie});

  void _showMovieDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF232323),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                movie.posterPath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          movie.fullPosterPath,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white70, size: 60),
                        ),
                      )
                    : const Icon(Icons.movie, color: Colors.white70, size: 60),
                const SizedBox(height: 16),
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Color(0xFFFFC300),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  movie.overview,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFC300)),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFFFFC300), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          movie.releaseDate,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMovieDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF232323),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: movie.posterPath.isNotEmpty
                    ? Image.network(
                        movie.fullPosterPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white70, size: 60),
                      )
                    : const Icon(Icons.movie, color: Colors.white70, size: 60),
              ),
              Container(
                color: Colors.black.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    color: Color(0xFFFFC300),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate {
  final MovieProvider movieProvider;
  MovieSearchDelegate(this.movieProvider);

  @override
  String get searchFieldLabel => 'Buscar películas';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF101010),
        iconTheme: IconThemeData(color: Color(0xFFFFC300)),
        titleTextStyle: TextStyle(color: Color(0xFFFFC300), fontSize: 20),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: const Color(0xFF181818),
      child: const Center(
        child: Text('Busca una película', style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    movieProvider.searchMovies(query);
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFFC300)));
        }
        if (provider.error.isNotEmpty) {
          return Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.redAccent)));
        }
        final movies = provider.searchResults;
        if (movies.isEmpty) {
          return const Center(child: Text('No hay resultados', style: TextStyle(color: Colors.white70)));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: movies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieCard(movie: movie);
          },
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.search, color: Color(0xFFFFC300)),
        onPressed: () {
          movieProvider.searchMovies(query);
          showResults(context);
        },
      ),
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Color(0xFFFFC300)),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFFFFC300)),
      onPressed: () => close(context, null),
    );
  }
}