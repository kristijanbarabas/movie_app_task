import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app_bloc/core/usecase/usecase.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/entities/popular_movies.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/repositories/popular_movies_repository.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/popular_movies_model.dart';

// Three use cases, GetPopularMoviesUseCase, GetCastListUseCase, and GetSearchUseCase, which are used to fetch data from a PopularMoviesRepository.

/// GetPopularMoviesUseCase retrieves a list of popular movies and returns it in the form of a PopularMovies entity. The use case requires a pageNumber parameter to be passed to it, which specifies the page of the movie list to be fetched.
class GetPopularMoviesUseCase implements UseCase<PopularMovies, Params?> {
  final PopularMoviesRepository? repository;

  const GetPopularMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, PopularMovies?>?>? call(Params? params) async {
    return await repository!.getPopularMovies(pageNumber: params!.pageNumber!);
  }
}

/// GetCastListUseCase retrieves the cast list for a specific movie, identified by its movieId. The cast list is returned as a list of CastListModel entities.
class GetCastListUseCase
    implements UseCaseCastList<List<CastListModel?>, Params?> {
  final PopularMoviesRepository? repository;

  const GetCastListUseCase(this.repository);

  @override
  Future<Either<Failure?, List<CastListModel?>?>?>? call(Params? params) async {
    return await repository!.getCastList(movieId: params!.movieId!);
  }
}

/// GetSearchUseCase searches for movies based on the query parameter and returns a list of MovieModel entities. The year parameter can also be passed to this use case to filter the search results by year.
class GetSearchUseCase implements SearchUseCase<List<MovieModel>, Params?> {
  final PopularMoviesRepository? repository;

  const GetSearchUseCase(this.repository);

  @override
  Future<Either<Failure?, List<MovieModel>?>?>? call(Params? params) async {
    return await repository!
        .getSearchedMovies(query: params!.query!, year: params.year!);
  }
}

/// Params is a class that is used to pass parameters to the use cases. It contains pageNumber, movieId, query, and year properties.
class Params extends Equatable {
  final int? pageNumber;
  final int? movieId;
  final String? query;
  final int? year;

  const Params({this.pageNumber, this.movieId, this.query, this.year});

  @override
  List<Object?> get props => [pageNumber, movieId, query];
}
