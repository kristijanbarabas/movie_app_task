// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'popular_movies_bloc.dart';

// These are the events that can be dispatched to the PopularMoviesBloc.
// GetPopularMovies is used to get the list of popular movies.
// GetCast is used to get the cast list of a movie.
// AddRemoveFavorite is used to add or remove a movie from the favorites list.
// LoadMyState is used to load the saved state of the PopularMoviesBloc.
// SaveMyState is used to save the current state of the PopularMoviesBloc.
// SearchForMovies is used to search for movies based on the specified query, year, yearIsSelected, and selected genres.

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class GetPopularMovies extends PopularMoviesEvent {}

class GetCast extends PopularMoviesEvent {
  final int movieId;
  const GetCast({
    required this.movieId,
  });

  @override
  List<Object> get props => [movieId];
}

class AddRemoveFavorite extends PopularMoviesEvent {
  final MovieModel movie;

  const AddRemoveFavorite({required this.movie});

  @override
  List<Object> get props => [movie];
}

class LoadMyState extends PopularMoviesEvent {
  final PopularMoviesState state;

  const LoadMyState(this.state);
  @override
  List<Object> get props => [state];
}

class SaveMyState extends PopularMoviesEvent {
  final List<MovieModel> favoriteMovies;

  const SaveMyState(this.favoriteMovies);
  @override
  List<Object> get props => [favoriteMovies];
}

class GetSearchedMovies extends PopularMoviesEvent {
  final String query;
  final int year;
  final bool yearIsSelected;
  final List selectedGenres;

  const GetSearchedMovies(
      {this.year = 0,
      required this.query,
      this.yearIsSelected = false,
      this.selectedGenres = const []});
  @override
  List<Object> get props => [query, year, yearIsSelected, selectedGenres];
}
