import 'package:cinefy/ui/providers/storage/favorite_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie_entity.dart';
import '../../widgets/widgets.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);
  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLoading = false;
  bool isLastpage = false;

  @override
  void initState() {
    super.initState();
    loadNextpage();
  }

  void loadNextpage() async {
    if (isLoading || isLastpage) return;
    isLoading = true;
    final List<Movie> movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;
    if (movies.isEmpty) isLastpage = true;
  }

  @override
  Widget build(BuildContext context) {
    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();

    return Scaffold(
      body: MovieMansory(
        movies: favoritesMovies,
        loadNextPage: loadNextpage,
      ),
    );
  }
}
