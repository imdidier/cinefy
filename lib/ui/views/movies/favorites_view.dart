import 'package:cinefy/ui/providers/storage/favorite_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    if (favoritesMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              color: colors.primary,
              size: 80,
            ),
            Text(
              '¡Ooh no!',
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            const Text(
              'No tienes feliculas favoritas',
              style: TextStyle(fontSize: 20, color: Colors.black38),
            ),
            const SizedBox(height: 15),
            FilledButton.tonal(
              onPressed: () => context.go('/home/0'),
              child: const Text('Marca algunas'),
            )
          ],
        ),
      );
    }
    return Scaffold(
      body: MovieMansory(
        movies: favoritesMovies,
        loadNextPage: loadNextpage,
      ),
    );
  }
}
