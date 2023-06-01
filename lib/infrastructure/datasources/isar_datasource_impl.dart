import 'package:cinefy/domain/datasources/local_storage_datasource.dart';
import 'package:cinefy/domain/entities/movie_entity.dart';
import 'package:isar/isar.dart';

class IsarDatasourceImpl extends LocalStorageDatasource {
  late Future<Isar> dataBase;

  IsarDatasourceImpl() {
    dataBase = openDataBase();
  }

  Future<Isar> openDataBase() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([MovieSchema], directory: '', inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await dataBase;
    final Movie? isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();

    return isFavoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await dataBase;
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await dataBase;

    final Movie? favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();
    if (favoriteMovie != null) {
      //Eliminar datos de Isar
      isar.writeTxnSync(() => isar.movies.delete(favoriteMovie.isarId!));
      return;
    }
    //Insertar datos en la base de datos Isar
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
