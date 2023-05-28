import 'package:cinefy/domain/datasources/actors_datasources.dart';
import 'package:cinefy/domain/entities/actor.dart';
import 'package:cinefy/infrastructure/mappers/actor_mapper.dart';
import 'package:cinefy/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

import '../../config/constans/environment.dart';

class ActorMovieDBDatasourceImpl extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/movie',
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'es-CO',
      },
    ),
  );

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(response.data);
    final List<Actor> actors = creditsResponse.cast
        .map((actor) => ActorMapper.castToEntity(actor))
        .toList();
    return actors;
  }
}
