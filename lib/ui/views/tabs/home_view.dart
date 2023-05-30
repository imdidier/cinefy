import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie_entity.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(firstLoadingProvider)) return const SplashLoader();

    final List<Movie> nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final List<Movie> popularMovies = ref.watch(popularMoviesProvider);
    final List<Movie> upcomingMovies = ref.watch(upcomingMoviesProvider);
    final List<Movie> topRatedMovies = ref.watch(topRatedMoviesProvider);
    final List<Movie> slideShowMovies = ref.watch(moviesSlideshowProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          leadingWidth: 0,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  // const CustomAppbar(),
                  MoviesSlideshow(movies: slideShowMovies),
                  MovieHorizontalList(
                    movies: nowPlayingMovies,
                    title: 'En cines',
                    subTitle: 'Viernes 26',
                    loadNextPage: () => ref
                        .read(nowPlayingMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  MovieHorizontalList(
                    movies: popularMovies,
                    title: 'Populares',
                    subTitle: 'Top calientes',
                    loadNextPage: () =>
                        ref.read(popularMoviesProvider.notifier).loadNextPage(),
                  ),
                  MovieHorizontalList(
                    movies: topRatedMovies,
                    title: 'Mejor calificadas',
                    loadNextPage: () => ref
                        .read(topRatedMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  MovieHorizontalList(
                    movies: upcomingMovies,
                    title: 'Próximamente',
                    subTitle: 'EL mes que viene',
                    loadNextPage: () => ref
                        .read(upcomingMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}
