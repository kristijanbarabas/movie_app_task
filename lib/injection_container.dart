import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app_bloc/core/network/network_info.dart';
import 'package:movie_app_bloc/features/popular_movies/data/datasources/popular_movies_local_data_source.dart';
import 'package:movie_app_bloc/features/popular_movies/data/datasources/popular_movies_remote_data_source.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/repositories/popular_movies_repository.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/popular_movies/data/repositories/popular_movies_repository_impl.dart';

// Dependency injection framework using the GetIt library.
//It uses a singleton pattern to register and retrieve instances of classes as dependencies.
final sl = GetIt.instance;

/// It starts by registering the PopularMoviesBloc which depends on several other objects.
/// These objects are either registered as a singleton (when they are requested only once when the app starts) or as a lazy singleton (when they are requested as a dependency for other classes).
Future<void> init() async {
  //! Features - Popular Movies
  sl.registerFactory(() => PopularMoviesBloc(
      getPopularMoviesData: sl(),
      getCastListUseCase: sl(),
      popularMoviesLocalDataSource: sl(),
      getSearchUseCase: sl()));

  //! Use cases - singleton is registered when the app starts, the lazy singelton is registered when it's requested as a dependency for some other class
  sl.registerLazySingleton(() => GetPopularMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetCastListUseCase(sl()));
  sl.registerLazySingleton(() => GetSearchUseCase(sl()));

  //! Repository
  sl.registerLazySingleton<PopularMoviesRepository>(() =>
      PopularMoviesRepositoryImpl(
          localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));

  //! Datasources
  sl.registerLazySingleton<PopularMoviesRemoteDataSource>(
      () => PopularMoviesRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PopularMoviesLocalDataSource>(
      () => PopularMoviesLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));

  //! External
  // Extract the await to get the instance outside of the registration of the singleton
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
