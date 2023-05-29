import 'package:cinefy/domain/entities/movie_entity.dart';
import 'package:cinefy/domain/repositories/movies_repository.dart';

import '../datasources/moviedb_datasource_impl.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviedbDatasourceImpl datasourceImpl;
  MovieRepositoryImpl(this.datasourceImpl);
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasourceImpl.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasourceImpl.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasourceImpl.getTopRated(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasourceImpl.getUpcoming(page: page);
  }

  @override
  Future<Movie> getMovieById(String movieId) {
    return datasourceImpl.getMovieById(movieId);
  }

  @override
  Future<List<Movie>> searchMovies(String query) {
    return datasourceImpl.searchMovies(query);
  }
}
