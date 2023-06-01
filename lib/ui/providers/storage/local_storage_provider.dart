import 'package:cinefy/infrastructure/datasources/isar_datasource_impl.dart';
import 'package:cinefy/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageReposirotyProvider =
    Provider((ref) => LocalStorageRepositoryImpl(IsarDatasourceImpl()));
