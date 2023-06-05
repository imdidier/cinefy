import 'package:cinefy/domain/entities/actor.dart';
import 'package:cinefy/domain/repositories/actors_reporitory.dart';
import 'package:cinefy/infrastructure/datasources/actor_moviedb_datasource_impl.dart';

class ActorMovieDBRepositoryImpl extends ActorsRepository {
  final ActorMovieDBDatasourceImpl datasourceImpl;
  ActorMovieDBRepositoryImpl(this.datasourceImpl);
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasourceImpl.getActorsByMovie(movieId);
  }
}
