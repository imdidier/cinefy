import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/movie_entity.dart';

class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies;
  const MoviesSlideshow({Key? key, required this.movies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Swiper(
        viewportFraction: 0.75,
        scale: 0.85,
        autoplay: true,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(bottom: 0),
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary,
          ),
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slider(
          movie: movies[index],
        ),
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  final Movie movie;
  const _Slider({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Colors.black38,
          blurRadius: 5,
          offset: Offset(0, 8),
        )
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black26));
              }
              return FadeIn(child: child);
            },
          ),
        ),
      ),
    );
  }
}
