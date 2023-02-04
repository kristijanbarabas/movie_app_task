part of 'popular_movies_bloc.dart';

// This code defines a Flutter app state management using the Equatable class to manage the states of popular movies, including the movies that are searched for and the movies that are marked as favorites.
//The PopularMoviesState class has fields for the status, list of popular movies, cast list, success status, error message, list of favorite movies, and list of searched movies.
//The toMap and fromMap methods convert the data between a Map and the state object. The toJson and fromJson methods convert the data between a JSON string and the state object.
//There are also four subclasses of PopularMoviesState: Empty, Loading, Loaded, and Error.
//The Loaded class is used when the movies have been successfully loaded, and the Error class is used when there was an error. The SearchIsLoading class is used when the search is in progress.

enum PopularMoviesSearchStatus { empty, loading, success, error }

class PopularMoviesState extends Equatable {
  final PopularMoviesSearchStatus searchStatus;
  final List<MovieModel> popularMovies;
  final List<CastListModel?> castList;
  final bool success;
  final String errorMessage;
  final List<MovieModel> favoriteMovies;
  final List<MovieModel> searchedMovies;

  const PopularMoviesState({
    this.searchStatus = PopularMoviesSearchStatus.empty,
    this.success = true,
    this.popularMovies = const <MovieModel>[],
    this.castList = const [],
    this.errorMessage = "",
    this.favoriteMovies = const <MovieModel>[],
    this.searchedMovies = const <MovieModel>[],
  });

  @override
  List<Object?> get props => [
        searchStatus,
        popularMovies,
        castList,
        success,
        errorMessage,
        favoriteMovies,
        searchedMovies
      ];

  PopularMoviesState copyWith({
    PopularMoviesSearchStatus? searchStatus,
    List<MovieModel>? popularMovies,
    List<CastListModel>? castList,
    bool? success,
    String? errorMessage,
    List<MovieModel>? favoriteMovies,
    List<MovieModel>? searchedMovies,
  }) {
    return PopularMoviesState(
      searchStatus: searchStatus ?? this.searchStatus,
      popularMovies: popularMovies ?? this.popularMovies,
      castList: castList ?? this.castList,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      searchedMovies: searchedMovies ?? this.searchedMovies,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'movies': popularMovies.map((x) => x.toMap()).toList(),
      'castList': castList.map((x) => x!.toMap()).toList(),
      'success': success,
      'errorMessage': errorMessage,
      'favoriteMovies': favoriteMovies.map((x) => x.toMap()).toList(),
      'searchedMovies': searchedMovies.map((x) => x.toMap()).toList(),
    };
  }

  factory PopularMoviesState.fromMap(Map<String, dynamic> map) {
    return PopularMoviesState(
      popularMovies: List<MovieModel>.from(
        (map['movies']).map<MovieModel>(
          (x) => MovieModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      castList: List<CastListModel>.from(
        (map['castList']).map<CastListModel>(
          (x) => CastListModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      success: map['success'] as bool,
      errorMessage: map['errorMessage'] as String,
      favoriteMovies: List<MovieModel>.from(
        (map['favoriteMovies']).map<Movie>(
          (x) => MovieModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      searchedMovies: List<MovieModel>.from(
        (map['favoriteMovies']).map<Movie>(
          (x) => MovieModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PopularMoviesState.fromJson(String source) =>
      PopularMoviesState.fromMap(json.decode(source) as Map<String, dynamic>);
}

// PopularMoviesInitial is Empty
class Empty extends PopularMoviesState {}

class Loading extends PopularMoviesState {}

class Loaded extends PopularMoviesState {
  @override
  final PopularMoviesSearchStatus searchStatus;
  @override
  final bool success;
  @override
  final List<MovieModel> searchedMovies;
  @override
  final List<MovieModel> popularMovies;
  @override
  final List<MovieModel> favoriteMovies;
  @override
  final List<CastListModel?> castList;

  const Loaded(
      {this.searchStatus = PopularMoviesSearchStatus.empty,
      this.success = true,
      this.searchedMovies = const [],
      this.favoriteMovies = const [],
      this.popularMovies = const [],
      this.castList = const []})
      : super(searchedMovies: searchedMovies);
}

class Error extends PopularMoviesState {
  final String error;

  const Error({required this.error});
}

class SearchIsLoading extends PopularMoviesState {}
