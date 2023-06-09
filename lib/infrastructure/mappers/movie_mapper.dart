import 'package:cinefy/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinefy/infrastructure/models/moviedb/movie_moviedb.dart';

import '../../domain/entities/movie_entity.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB movieDB) => Movie(
        adult: movieDB.adult,
        backdropPath: (movieDB.backdropPath != '')
            ? 'https://image.tmdb.org/t/p/w400${movieDB.backdropPath}'
            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_hWubOwCUsUchCRvVuMya7QQXwsSTuuhpHA&usqp=CAU',
        genreIds: movieDB.genreIds.map((e) => e.toString()).toList(),
        id: movieDB.id,
        originalLanguage: movieDB.originalLanguage,
        originalTitle: movieDB.originalTitle,
        overview: movieDB.overview,
        popularity: movieDB.popularity,
        posterPath: (movieDB.posterPath != '')
            ? 'https://image.tmdb.org/t/p/w400${movieDB.posterPath}'
            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_hWubOwCUsUchCRvVuMya7QQXwsSTuuhpHA&usqp=CAU',
        releaseDate: movieDB.releaseDate ?? DateTime.now(),
        title: movieDB.title,
        video: movieDB.video,
        voteAverage: movieDB.voteAverage,
        voteCount: movieDB.voteCount,
      );

  static Movie movieDetailsToEntity(MovieDetails movieDB) => Movie(
        adult: movieDB.adult,
        backdropPath: (movieDB.backdropPath != '')
            ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_hWubOwCUsUchCRvVuMya7QQXwsSTuuhpHA&usqp=CAU',
        genreIds: movieDB.genres.map((e) => e.name.toString()).toList(),
        id: movieDB.id,
        originalLanguage: movieDB.originalLanguage,
        originalTitle: movieDB.originalTitle,
        overview: movieDB.overview,
        popularity: movieDB.popularity,
        posterPath: (movieDB.posterPath != '')
            ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
            : 'sin-poster',
        releaseDate: movieDB.releaseDate,
        title: movieDB.title,
        video: movieDB.video,
        voteAverage: movieDB.voteAverage,
        voteCount: movieDB.voteCount,
      );
}
