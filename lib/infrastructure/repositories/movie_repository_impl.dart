import 'package:cinefy/domain/entities/movie_entity.dart';
import 'package:cinefy/domain/repositories/movies_repository.dart';

import '../datasources/moviedb_datasource_impl.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviedbDatasourceImpl datasource;
  MovieRepositoryImpl(this.datasource);
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }
}
