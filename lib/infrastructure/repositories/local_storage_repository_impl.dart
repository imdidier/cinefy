import 'package:cinefy/domain/entities/movie_entity.dart';
import 'package:cinefy/domain/repositories/local_storage_repository.dart';
import 'package:cinefy/infrastructure/datasources/isar_datasource_impl.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final IsarDatasourceImpl datasourceImpl;
  LocalStorageRepositoryImpl(this.datasourceImpl);
  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasourceImpl.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    return datasourceImpl.loadMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    return datasourceImpl.toggleFavorite(movie);
  }
}
