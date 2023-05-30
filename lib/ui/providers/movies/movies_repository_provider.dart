import 'package:cinefy/infrastructure/datasources/moviedb_datasource_impl.dart';
import 'package:cinefy/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Este repositorio es inmutable
final movieRepositoryProvider = Provider(
  (ref) {
    return MovieRepositoryImpl(MoviedbDatasourceImpl());
  },
);
