import 'package:cinefy/infrastructure/datasources/actor_moviedb_datasource_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/repositories/actor_moviedb_repository_impl.dart';

//Este repositorio es inmutable
final actorRepositoryProvider = Provider(
  (ref) {
    return ActorMovieDBRepositoryImpl(ActorMovieDBDatasourceImpl());
  },
);
