import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../config/helpers/human_format.dart';
import '../../domain/entities/movie_entity.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;
  List<Movie> initialMovies;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });

  void clearStreams() {
    debouncedMovies.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(
      const Duration(milliseconds: 500),
      () async {
        // if (query.isEmpty) {
        //   debouncedMovies.add([]);
        //   return;
        // }
        final movies = await searchMovies(query);
        debouncedMovies.add(movies);
        initialMovies = movies;
        debouncedMovies.add(movies);
        isLoadingStream.add(false);
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              infinite: true,
              spins: 10,
              duration: const Duration(seconds: 20),
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.refresh_outlined),
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration(milliseconds: 300),
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear_outlined),
            ),
          );
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back_ios_new,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions(context);
  }

  Widget buildResultsAndSuggestions(BuildContext context) {
    return StreamBuilder(
      //future: searchMovies(query),
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieItem(
              movie: movies[index],
              onMovieSelected: (contex, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: SizedBox(
        height: 155,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      movie.posterPath,
                      fit: BoxFit.cover,
                      width: 90,
                    ),
                  ),
                ),
                SizedBox(
                  width: 350,
                  height: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: textStyle.titleMedium,
                      ),
                      Text(
                        movie.overview,
                        maxLines: 4,
                        style: textStyle.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_half_outlined,
                            color: Colors.yellow.shade700,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: textStyle.bodyMedium!
                                .copyWith(color: Colors.yellow.shade700),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            HumanFormat.number(movie.popularity),
                            style: textStyle.bodySmall,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
