import 'package:cinefy/ui/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie_entity.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home-screen';

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigator(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    // final List<Movie> nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final List<Movie> slideShowMovies = ref.watch(moviesSlideshowProvider);
    return Column(
      children: [
        const CustomAppbar(),
        MoviesSlideshow(movies: slideShowMovies),
        MovieHorizontalList(
          movies: slideShowMovies,
          title: 'En cines',
          subTitle: 'Lunes pai',
        ),
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: nowPlayingMovies.length,
        //     itemBuilder: (context, index) {
        //       final Movie movie = nowPlayingMovies[index];
        //       return ListTile(
        //         title: Text(
        //           movie.title,
        //         ),
        //         subtitle: Text(
        //           movie.overview,
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
