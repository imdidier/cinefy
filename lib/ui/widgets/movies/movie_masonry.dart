import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../domain/entities/movie_entity.dart';
import '../widgets.dart';

class MovieMansory extends StatefulWidget {
  final List<Movie> movies;

  final VoidCallback? loadNextPage;
  const MovieMansory({
    Key? key,
    required this.movies,
    this.loadNextPage,
  }) : super(key: key);

  @override
  State<MovieMansory> createState() => _MovieMansoryState();
}

class _MovieMansoryState extends State<MovieMansory> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() async {
      if (widget.loadNextPage == null) return;

      if ((_scrollController.position.pixels + 150 >=
          _scrollController.position.maxScrollExtent)) {
        await Future.delayed(const Duration(milliseconds: 1200));
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MasonryGridView.count(
        controller: _scrollController,
        crossAxisCount: 3,
        itemCount: widget.movies.length,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemBuilder: (context, index) {
          final Movie movie = widget.movies[index];
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 40),
                MoviePosterLink(movie: movie),
              ],
            );
          }
          return MoviePosterLink(movie: movie);
        },
      ),
    );
  }
}
