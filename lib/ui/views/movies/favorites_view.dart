import 'package:cinefy/ui/providers/storage/favorite_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie_entity.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);
  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();

    return Scaffold(
      body: ListView.builder(
        itemCount: favoritesMovies.length,
        itemBuilder: (context, index) {
          final Movie movie = favoritesMovies[index];
          return ListTile(
            title: Text(
              movie.title,
            ),
          );
        },
      ),
    );
  }
}
