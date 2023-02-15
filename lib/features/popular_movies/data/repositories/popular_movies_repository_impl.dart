import 'package:movie_app_bloc/core/error/exceptions.dart';
import 'package:movie_app_bloc/core/network/network_info.dart';
import 'package:movie_app_bloc/features/popular_movies/data/datasources/popular_movies_local_data_source.dart';
import 'package:movie_app_bloc/features/popular_movies/data/datasources/popular_movies_remote_data_source.dart';
import 'package:movie_app_bloc/features/popular_movies/data/models/popular_movies_model.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/entities/popular_movies.dart';
import 'package:movie_app_bloc/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/repositories/popular_movies_repository.dart';

/// This code defines an implementation of the PopularMoviesRepository which retrieves movie information from both the remote and local data sources.
/// It has three dependencies, the remoteDataSource, the localDataSource, and the networkInfo.
class PopularMoviesRepositoryImpl implements PopularMoviesRepository {
  final PopularMoviesRemoteDataSource? remoteDataSource;
  final PopularMoviesLocalDataSource? localDataSource;
  final NetworkInfo? networkInfo;

  PopularMoviesRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  /// The getPopularMovies method first checks if the device is connected to the network by using the networkInfo.isConnected method.
  /// If the device is connected, it tries to get the popular movies data from the remote data source through the remoteDataSource.getPopularMovies method.
  /// If this operation is successful, the popular movies data is returned as a right Either object.
  /// If the device is not connected or if there is an exception, a left Either object with a ServerFailure is returned.
  @override
  Future<Either<Failure, PopularMovies?>?>? getPopularMovies(
      {required int pageNumber}) async {
    if (await networkInfo!.isConnected!) {
      try {
        final remotePopularMovies =
            await remoteDataSource!.getPopularMovies(pageNumber: pageNumber);
        return Right(remotePopularMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(DeviceIsOfflineFailure());
    }
  }

  /// The getCastList method gets the cast list of a movie from the remote data source.
  /// If the device is connected to the network, it returns the cast list as a right Either object, otherwise, it returns a left Either object with a ServerFailure.
  @override
  Future<Either<Failure, List<CastListModel?>?>?>? getCastList(
      {required int movieId}) async {
    if (await networkInfo!.isConnected!) {
      try {
        final castList = await remoteDataSource!.getCastList(movieId: movieId);
        return Right(castList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(DeviceIsOfflineFailure());
    }
  }

  /// The searchMovies method searches for movies based on the query and year passed as arguments.
  /// If the device is connected to the network, it returns the search results as a right Either object, otherwise, it returns a left Either object with a NoSearchResultsFailure.
  @override
  Future<Either<Failure, List<MovieModel>?>?>? getSearchedMovies(
      {required String query, int year = 0}) async {
    if (await networkInfo!.isConnected!) {
      try {
        final searchMoviesResults =
            await remoteDataSource!.getSearchedMovies(query: query, year: year);
        return Right(searchMoviesResults);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(DeviceIsOfflineFailure());
    }
  }
}
