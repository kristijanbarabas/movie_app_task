part of 'popular_movies_bloc.dart';

// This code defines a Flutter app state management using the Equatable class to manage the states of popular movies, including the movies that are searched for and the movies that are marked as favorites.

// This enumeration defines the status of usecases. It can be in one of the four states: empty, loading, success, and error.

enum PopularMoviesStatus { empty, loading, success, error }

enum FavoriteMoviesStatus { empty, loading, success, error }

enum SearchedMoviesStatus { empty, loading, success, error }

enum CastListStatus { empty, loading, success, error }

class PopularMoviesState extends Equatable {
  final PopularMoviesStatus popularMoviesStatus;
  final FavoriteMoviesStatus favoriteMoviesStatus;
  final SearchedMoviesStatus searchedMoviesStatus;
  final CastListStatus castListStatus;
  final List<MovieModel> popularMovies;
  final List<CastListModel?> castList;
  final bool success;
  final String errorMessage;
  final List<MovieModel> favoriteMovies;
  final List<MovieModel> searchedMovies;

  const PopularMoviesState({
    this.popularMoviesStatus = PopularMoviesStatus.empty,
    this.favoriteMoviesStatus = FavoriteMoviesStatus.empty,
    this.searchedMoviesStatus = SearchedMoviesStatus.empty,
    this.castListStatus = CastListStatus.empty,
    this.success = true,
    this.popularMovies = const <MovieModel>[],
    this.castList = const [],
    this.errorMessage = "",
    this.favoriteMovies = const <MovieModel>[],
    this.searchedMovies = const <MovieModel>[],
  });

  @override
  List<Object?> get props => [
        popularMoviesStatus,
        favoriteMoviesStatus,
        searchedMoviesStatus,
        castListStatus,
        popularMovies,
        castList,
        success,
        errorMessage,
        favoriteMovies,
        searchedMovies
      ];

  PopularMoviesState copyWith({
    PopularMoviesStatus? popularMoviesStatus,
    FavoriteMoviesStatus? favoriteMoviesStatus,
    SearchedMoviesStatus? searchedMoviesStatus,
    CastListStatus? castListStatus,
    List<MovieModel>? popularMovies,
    List<CastListModel>? castList,
    bool? success,
    String? errorMessage,
    List<MovieModel>? favoriteMovies,
    List<MovieModel>? searchedMovies,
  }) {
    return PopularMoviesState(
      popularMoviesStatus: popularMoviesStatus ?? this.popularMoviesStatus,
      favoriteMoviesStatus: favoriteMoviesStatus ?? this.favoriteMoviesStatus,
      searchedMoviesStatus: searchedMoviesStatus ?? this.searchedMoviesStatus,
      castListStatus: castListStatus ?? this.castListStatus,
      popularMovies: popularMovies ?? this.popularMovies,
      castList: castList ?? this.castList,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      searchedMovies: searchedMovies ?? this.searchedMovies,
    );
  }
}

class PopularMoviesInitial extends PopularMoviesState {}
