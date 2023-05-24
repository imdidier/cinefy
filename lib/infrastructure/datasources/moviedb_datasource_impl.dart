import 'package:cinefy/config/constans/environment.dart';
import 'package:cinefy/domain/datasources/movies_datasources.dart';
import 'package:cinefy/domain/entities/movie_entity.dart';
import 'package:cinefy/infrastructure/mappers/movie_mapper.dart';
import 'package:cinefy/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasourceImpl extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'es-CO',
      },
    ),
  );

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');
    final MovieDbResponse movieDBResponse =
        MovieDbResponse.fromJson(response.data);
    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'sin-poster')
        .map((movieDB) => MovieMapper.movieDBToEntity(movieDB))
        .toList();
    return movies;
  }
}
