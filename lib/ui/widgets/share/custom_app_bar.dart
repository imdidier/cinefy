import 'package:cinefy/ui/delegates/search_movie_delegate.dart';
import 'package:cinefy/ui/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie_entity.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.movie_creation_outlined, color: colors.primary),
              const SizedBox(width: 10),
              Text('Cinefy', style: titleStyle),
              const Spacer(),
              IconButton(
                onPressed: () {
                  final searchMovies = ref.read(searchedMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);
                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      searchMovies: ref
                          .read(searchedMoviesProvider.notifier)
                          .searchMoviesByQuery,
                      initialMovies: searchMovies,
                    ),
                  ).then((movie) {
                    if (movie == null) return;
                    context.push('/movie/${movie.id}');
                  });
                },
                icon: const Icon(Icons.search_outlined),
              )
            ],
          ),
        ),
      ),
    );
  }
}
