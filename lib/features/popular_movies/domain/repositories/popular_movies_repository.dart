import 'package:dartz/dartz.dart';
import 'package:movie_app_bloc/core/error/failures.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/entities/popular_movies.dart';

import '../../data/models/popular_movies_model.dart';

/// PopularMoviesRepository is an abstract class that serves as an interface for retrieving data related to popular movies.
/// All methods return a Future of an Either object, where the Either type is defined in the dartz package and is used to represent either a success or a failure result. In case of a failure, a Failure object is returned.
abstract class PopularMoviesRepository {
  Future<Either<Failure, PopularMovies?>?>? getPopularMovies(
      {required int pageNumber});
  Future<Either<Failure, List<CastListModel?>?>?>? getCastList(
      {required int movieId});
  Future<Either<Failure, List<MovieModel>?>?>? getSearchedMovies(
      {required String query, int year = 0});
}
