import 'package:cinefy/config/constans/environment.dart';
import 'package:cinefy/domain/datasources/movies_datasources.dart';
import 'package:cinefy/domain/entities/movie_entity.dart';
import 'package:cinefy/infrastructure/mappers/movie_mapper.dart';
import 'package:cinefy/infrastructure/models/moviedb/movie_details.dart';
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

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final MovieDbResponse movieDBResponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'sin-poster')
        .map((movieDB) => MovieMapper.movieDBToEntity(movieDB))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response =
        await dio.get('/movie/popular', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response =
        await dio.get('/movie/top_rated', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String movieId) async {
    final response = await dio.get('/movie/$movieId');
    if (response.statusCode != 200) {
      throw Exception('Movie with id: $movieId not found');
    }
    final movieDetails = MovieDetails.fromJson(response.data);

    final movie = MovieMapper.movieDetailsToEntity(movieDetails);
    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    final response =
        await dio.get('/search/movie', queryParameters: {'query': query});
    return _jsonToMovies(response.data);
  }
}
