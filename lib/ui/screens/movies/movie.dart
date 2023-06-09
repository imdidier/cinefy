import 'package:cinefy/ui/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/actor.dart';
import '../../../domain/entities/movie_entity.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final String movieId;
  const MovieScreen({Key? key, required this.movieId}) : super(key: key);
  static const String name = 'movie-screen';

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieDetailsProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieDetailsProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppbar(
            movie: movie,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyle.titleLarge,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                    ),
                    Text(
                      movie.overview,
                      maxLines: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map(
                (gender) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  //TODO: Agregar tap a los chips para que lleven a recomendaciones de películas
                  child: Chip(
                    label: Text(
                      gender,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        _ActorsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 60),
      ],
    );
  }
}

final isFavoriteMovieProvider = FutureProvider.family.autoDispose(
  (ref, int movieId) async {
    final localStorageRepository = ref.watch(localStorageReposirotyProvider);
    return localStorageRepository.isMovieFavorite(movieId);
  },
);

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final actorsByMovie = ref.watch(actorsByMovieProvider);
    if (actorsByMovie[movieId] == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final List<Actor>? actors = actorsByMovie[movieId];
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors!.length,
        itemBuilder: (context, index) {
          final Actor actor = actors[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath,
                    fit: BoxFit.cover,
                    width: 150,
                  ),
                ),
              ),
              const SizedBox(),
              SizedBox(
                width: 140,
                child: Text(
                  actor.name,
                  style: textStyle.titleMedium,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CustomSliverAppbar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppbar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue isFavoriteFuture =
        ref.watch(isFavoriteMovieProvider(movie.id));
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      actions: [
        IconButton(
          onPressed: () async {
            // await ref.read(localStorageReposirotyProvider).toggleFavorite(movie);
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavorite(movie);
            ref.invalidate(isFavoriteMovieProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite
                ? const Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite_border_outlined),
            error: (_, __) => throw UnimplementedError(),
            loading: () => const CircularProgressIndicator.adaptive(),
          ),
        ),
      ],
      backgroundColor: Colors.black26,
      expandedHeight: size.height * 0.666,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.contain,
              ),
            ),
            const _CustomGradient(
              colors: [
                Colors.black38,
                Colors.transparent,
              ],
              stops: [0.0, 0.3],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
            const _CustomGradient(
              colors: [
                Colors.black38,
                Colors.transparent,
              ],
              stops: [0.0, 0.3],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final List<double> stops;
  final Alignment begin;
  final Alignment end;
  final List<Color> colors;
  const _CustomGradient({
    required this.stops,
    required this.begin,
    required this.end,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: begin,
            stops: stops,
            end: end,
          ),
        ),
      ),
    );
  }
}
