import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../config/helpers/human_format.dart';
import '../../../domain/entities/movie_entity.dart';

class MovieHorizontalList extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;
  const MovieHorizontalList({
    Key? key,
    required this.movies,
    this.title,
    this.subTitle,
    this.loadNextPage,
  }) : super(key: key);

  @override
  State<MovieHorizontalList> createState() => _MovieHorizontalListState();
}

class _MovieHorizontalListState extends State<MovieHorizontalList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((_scrollController.position.pixels + 150 >=
          _scrollController.position.maxScrollExtent)) {
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
    return SizedBox(
      height: 380,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return FadeInRight(child: _Slide(movie: widget.movies[index]));
              },
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.movies.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 156,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 160,
                height: 250,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return Image.asset('assets/image-no-found.jpg');
                  }
                  return FadeIn(child: child);
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 160,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyle.titleMedium,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star_half_outlined, color: Colors.yellow),
              const SizedBox(width: 5),
              Text(
                '${movie.voteAverage}',
                style: textStyle.bodyMedium!.copyWith(color: Colors.yellow),
              ),
              const SizedBox(width: 5),
              Text(
                HumanFormat.number(movie.popularity),
                style: textStyle.bodySmall,
              )
            ],
          )
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final styleText = Theme.of(context).textTheme.titleLarge;
    return Container(
      padding: const EdgeInsets.only(top: 15),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: styleText,
            ),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subTitle!),
            ),
        ],
      ),
    );
  }
}
