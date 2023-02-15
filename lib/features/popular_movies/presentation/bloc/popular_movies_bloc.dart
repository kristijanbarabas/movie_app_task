import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/usecases/get_popular_movies.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/popular_movies_local_data_source.dart';
import '../../data/models/popular_movies_model.dart';
import '../../domain/entities/popular_movies.dart';
part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String deviceIsOfflineMessage = 'Device is offline...';

/// This code implements the Bloc pattern for managing the state of popular movie data, with various events triggering the corresponding actions.
/// The on statements listen to various events such as GetPopularMovies, GetCast, AddRemoveFavorite, LoadMyState, SaveMyState, SearchForMovies, and perform the corresponding actions.
class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  GetPopularMoviesUseCase? getPopularMoviesData;
  GetCastListUseCase? getCastListUseCase;
  GetSearchUseCase? getSearchUseCase;
  PopularMoviesLocalDataSource? popularMoviesLocalDataSource;

  int pageNumber = 1;
  @override
  PopularMoviesBloc(
      {required this.getPopularMoviesData,
      required this.getCastListUseCase,
      required this.popularMoviesLocalDataSource,
      required this.getSearchUseCase})
      : super(PopularMoviesInitial()) {
    ///When the page number is 1, it emits a Loading state and retrieves movie data from the API with the help of getPopularMoviesData function, passing in Params(pageNumber: pageNumber) as the argument. If the data is successfully retrieved, the state of the UI is updated with either the Loaded or Error state, determined by _eitherSuccessOrErrorStatePopularMovies function, by passing the retrieved data to it and waiting for the result. The page number is then incremented.
    /// For subsequent pages, the same process is repeated, without emitting the Loading state.
    on<GetPopularMovies>(
      (event, emit) async {
        if (pageNumber == 1) {
          emit(const PopularMoviesState(
              popularMoviesStatus: PopularMoviesStatus.loading));
          final failureOrPopularMovies =
              await getPopularMoviesData!(Params(pageNumber: pageNumber));
          if (failureOrPopularMovies != null) {
            // we need to await the future and then emit the proper state
            emit(await _eitherSuccessOrErrorStatePopularMovies(
                failureOrPopularMovies));
            pageNumber++;
          }
        } else {
          final failureOrPopularMovies =
              await getPopularMoviesData!(Params(pageNumber: pageNumber));
          if (failureOrPopularMovies != null) {
            // we need to await the future and then emit the proper state
            emit(await _eitherSuccessOrErrorStatePopularMovies(
                failureOrPopularMovies));
            pageNumber++;
          }
        }
      },
    );

    /// It retrieves the cast data using the getCastListUseCase function, passing in Params(movieId: event.movieId) as the argument, where event.movieId is the movie ID passed in from the event.
    /// If the data is successfully retrieved, the state of the UI is updated with either the Success or Error state,
    /// determined by _eitherSuccessOrErrorStateCastList function, by passing the retrieved data to it and waiting for the result.
    on<GetCast>((event, emit) async {
      final failureOrCastList =
          await getCastListUseCase!(Params(movieId: event.movieId));
      if (failureOrCastList != null) {
        emit(await _eitherSuccessOrErrorStateCastList(failureOrCastList));
      }
    });

    /// The function takes in one parameter: _addOrRemoveFavoriteMovie, which is the event handler that will be executed when the event is triggered.
    /// It will either add or remove a movie to/from the user's favorite list.
    on<AddRemoveFavorite>(_addOrRemoveFavoriteMovie);

    /// The function takes in one parameter: _loadMyState, which is the event handler that will be executed when the event is triggered.
    /// It will load the saved list of favorite movies from the cache
    on<LoadMyState>(_loadMyState);

    /// This code listens to the SaveMyState event and uses the popularMoviesLocalDataSource object to save the favorite movies to local storage.
    /// The function saveState takes a list of favoriteMovies as input and stores it in local storage.
    on<SaveMyState>((event, emit) async {
      await popularMoviesLocalDataSource!.saveState(state.favoriteMovies);
    });

    /// This code implements an event handler for the "SearchForMovies" event in a Bloc. When this event is triggered, the handler will emit a "Success" state with a status of "loading", and the favoriteMovies and popularMovies from the current state will not be changed.
    /// Then, it calls the "getSearchUseCase" which presumably returns either a failure or a list of search results, represented as a "failureOrSearchResults" object.
    /// If the "failureOrSearchResults" is not null, the handler will then call another method "_eitherSuccessOrErrorSearchResults" which takes the "failureOrSearchResults" and the original "SearchForMovies" event as arguments, and returns a "Success" state or an "Error" state. The resulting state is then emitted.
    on<GetSearchedMovies>((event, emit) async {
      emit(PopularMoviesState(
          popularMoviesStatus: state.popularMoviesStatus,
          favoriteMoviesStatus: state.favoriteMoviesStatus,
          searchedMoviesStatus: SearchedMoviesStatus.loading,
          favoriteMovies: state.favoriteMovies,
          popularMovies: state.popularMovies));

      final failureOrSearchResults =
          await getSearchUseCase!(Params(query: event.query, year: event.year));
      if (failureOrSearchResults != null) {
        emit(await _eitherSuccessOrErrorSearchResults(
            failureOrSearchResults, event));
      }
    });
  }

  /// This function maps a failure or a successful result from an API call to either a PopularMoviesState object in case of success or an Error object in case of failure.
  /// The failureOrPopularMovies parameter is an instance of Either which can either be a failure or a successful result. The Either type is used to represent values with two possibilities, one being a success and the other a failure.
  /// The function uses the fold method to unwrap the value from the Either instance.
  /// If the value is a failure, it maps the failure to a message using the _mapFailureToMessage function and returns an instance of Error with the error message.
  /// If the value is a success, it returns an instance of success with the updated list of popular movies by adding the new results to the existing list of popular movies in the state.
  /// If the API call was successful but returned an empty result, it returns a success object with a success property set to false.
  Future<PopularMoviesState> _eitherSuccessOrErrorStatePopularMovies(
    Either<Failure?, PopularMovies?> failureOrPopularMovies,
  ) async {
    return await failureOrPopularMovies.fold(
        (failure) => PopularMoviesState(
              popularMoviesStatus: PopularMoviesStatus.error,
              errorMessage: _mapFailureToMessage(failure: failure!),
            ), (movies) {
      if (movies != null) {
        return PopularMoviesState(
            popularMoviesStatus: PopularMoviesStatus.success,
            favoriteMoviesStatus: state.favoriteMoviesStatus,
            searchedMoviesStatus: state.searchedMoviesStatus,
            searchedMovies: state.searchedMovies,
            favoriteMovies: state.favoriteMovies,
            popularMovies: List.of(state.popularMovies)
              ..addAll(List<MovieModel>.from(movies.results!)));
      } else {
        // If the response is good but the results from the API call are empty that means that the end of the popular movies is reached
        // The user will then be displayed the message that he has reached the end
        // and the success state is changed to false because by default it is set to true
        return PopularMoviesState(
            popularMoviesStatus: PopularMoviesStatus.success,
            favoriteMoviesStatus: state.favoriteMoviesStatus,
            searchedMoviesStatus: state.searchedMoviesStatus,
            success: false,
            searchedMovies: state.searchedMovies,
            favoriteMovies: state.favoriteMovies,
            popularMovies: List.of(state.popularMovies));
      }
    });
  }

  /// This function maps a result of either a failure or a cast list to a PopularMoviesState.
  /// If the result is a failure, it returns an Error state with an error message.
  /// Otherwise, it returns a success state with the updated cast list and the unchanged popular movies, favorite movies, and searched movies.
  Future<PopularMoviesState> _eitherSuccessOrErrorStateCastList(
    Either<Failure?, List<CastListModel?>?> failureOrCastList,
  ) async {
    return await failureOrCastList.fold(
        (failure) => PopularMoviesState(
            searchedMoviesStatus: state.searchedMoviesStatus,
            favoriteMoviesStatus: state.favoriteMoviesStatus,
            popularMoviesStatus: state.popularMoviesStatus,
            castListStatus: CastListStatus.error,
            errorMessage: _mapFailureToMessage(failure: failure!)), (castList) {
      return PopularMoviesState(
          castListStatus: CastListStatus.success,
          popularMoviesStatus: state.popularMoviesStatus,
          favoriteMoviesStatus: state.favoriteMoviesStatus,
          searchedMoviesStatus: state.searchedMoviesStatus,
          castList: castList!,
          searchedMovies: state.searchedMovies,
          favoriteMovies: state.favoriteMovies,
          popularMovies: state.popularMovies);
    });
  }

  /// The function _eitherLoadedOrErrorSearchResults is a helper function that maps an Either object with a Failure type or a list of MovieModel objects to a PopularMoviesState object.
  /// The function uses the fold method to handle the two cases. If the Either object has a Failure type, the function returns an Error state with an error message generated by the _mapFailureToMessage function.
  /// If the Either object has a list of MovieModel objects, the function first checks if the year is selected in the SearchForMovies event and then performs some operations on the list of movies based on the selected year and genres.
  /// If the year is selected, the function filters the list of movies based on the selected genres, and if the year is not selected, the function filters the list of movies based on the selected genres.
  /// Finally, the function returns a success state with updated lists of favorite, popular, and searched movies.
  Future<PopularMoviesState> _eitherSuccessOrErrorSearchResults(
      Either<Failure?, List<MovieModel>?> failureOrSearchResults,
      GetSearchedMovies event) async {
    return await failureOrSearchResults.fold(
        (failure) => PopularMoviesState(
            popularMovies: state.popularMovies,
            favoriteMovies: state.favoriteMovies,
            popularMoviesStatus: state.popularMoviesStatus,
            favoriteMoviesStatus: state.favoriteMoviesStatus,
            searchedMoviesStatus: SearchedMoviesStatus.error,
            errorMessage: _mapFailureToMessage(failure: failure!)),
        (searchResults) {
      List<MovieModel> favoriteMovies = List.from(state.favoriteMovies);
      List<MovieModel> popularMovies = List.from(state.popularMovies);
      List<MovieModel> searchedMovies = searchResults!;

      //! YEAR IS SELECTED
      if (event.yearIsSelected == true) {
        // Check if the movies from the searchedMovies list are in in the favoriteMovies list
        // Overwrite them so that the favorite icon will be displayed in the search results
        for (var i = 0; i < searchedMovies.length; i++) {
          if (favoriteMovies.any((movie) => movie.id == searchedMovies[i].id)) {
            var favoriteMovie = favoriteMovies
                .firstWhere((movie) => movie.id == searchedMovies[i].id);
            searchedMovies[i] = favoriteMovie;
          }
        }
        // Check which movies match the selected genres and add them to the matchingMovies list
        List<MovieModel> matchingMovies = [];
        for (MovieModel movie in searchedMovies) {
          for (var genreId in event.selectedGenres) {
            if (movie.genreIds!.contains(genreId)) {
              matchingMovies.add(movie);
              break;
            }
          }
        }
        // If no genres were selected return the searchedMovies, otherwise return the matchingMovies
        return PopularMoviesState(
            popularMoviesStatus: state.popularMoviesStatus,
            favoriteMoviesStatus: state.favoriteMoviesStatus,
            castListStatus: state.castListStatus,
            searchedMoviesStatus: SearchedMoviesStatus.success,
            searchedMovies:
                event.selectedGenres.isEmpty ? searchedMovies : matchingMovies,
            favoriteMovies: favoriteMovies,
            popularMovies: popularMovies);
      } else {
        //! YEAR IS NOT SELECTED
        // Check if the movies from the searchedMovies list are in in the favoriteMovies list
        // Overwrite them so that the favorite icon will be displayed in the search results
        for (var i = 0; i < searchedMovies.length; i++) {
          if (favoriteMovies.any((movie) => movie.id == searchedMovies[i].id)) {
            var favoriteMovie = favoriteMovies
                .firstWhere((movie) => movie.id == searchedMovies[i].id);
            searchedMovies[i] = favoriteMovie;
          }
        }

        // Check which movies match the selected genres and add them to the matchingMovies list
        List<MovieModel> matchingMovies = [];
        for (MovieModel movie in searchedMovies) {
          for (var genreId in event.selectedGenres) {
            if (movie.genreIds!.contains(genreId)) {
              matchingMovies.add(movie);
              break;
            }
          }
        }
        // If no genres were selected return the searchedMovies, otherwise return the matchingMovies
        return PopularMoviesState(
            errorMessage: state.errorMessage,
            popularMoviesStatus: state.popularMoviesStatus,
            favoriteMoviesStatus: state.favoriteMoviesStatus,
            castListStatus: state.castListStatus,
            searchedMoviesStatus: SearchedMoviesStatus.success,
            searchedMovies:
                event.selectedGenres.isEmpty ? searchedMovies : matchingMovies,
            favoriteMovies: favoriteMovies,
            popularMovies: popularMovies);
      }
    });
  }

  /// The function takes in two parameters: event of type AddRemoveFavorite and emit of type Emitter<PopularMoviesState>, which are used to pass in the event and update the UI state, respectively.
  /// The state of the favorite, popular and searched movies lists is stored in variables favoriteMovies, popularMovies, and searchedMovies respectively.
  /// If the movie is not already a favorite, the function finds the index of the movie in the popular and searched movies lists and updates it to have the isFavorite attribute set to true, and adds the movie to the list of favorite movies.
  /// If the movie is already a favorite, the function finds the index of the movie in the popular and searched movies lists and updates it to have the isFavorite attribute set to false, and removes the movie from the list of favorite movies.
  /// Finally, the function updates the UI state with the updated lists by emitting a new success state.
  void _addOrRemoveFavoriteMovie(
      AddRemoveFavorite event, Emitter<PopularMoviesState> emit) {
    final state = this.state;
    List<MovieModel> favoriteMovies = List.from(state.favoriteMovies);
    List<MovieModel> popularMovies = List.from(state.popularMovies);
    List<MovieModel> searchedMovies = List.from(state.searchedMovies);
    if (event.movie.isFavorite == false) {
      var movieIndex = popularMovies.indexOf(event.movie);
      var searchedIndex = searchedMovies.indexOf(event.movie);
      if (popularMovies.contains(event.movie)) {
        popularMovies = List.from(popularMovies)
          ..remove(event.movie)
          ..insert(movieIndex, event.movie.copyWith(isFavorite: true));
      }
      if (searchedMovies.contains(event.movie)) {
        searchedMovies = List.from(searchedMovies)
          ..remove(event.movie)
          ..insert(searchedIndex, event.movie.copyWith(isFavorite: true));
      }
      favoriteMovies.add(event.movie.copyWith(isFavorite: true));
    } else {
      var movieIndex = popularMovies.indexOf(event.movie);
      var searchedIndex = searchedMovies.indexOf(event.movie);
      if (popularMovies.contains(event.movie)) {
        popularMovies = List.from(popularMovies)
          ..remove(event.movie)
          ..insert(movieIndex, event.movie.copyWith(isFavorite: false));
      }
      if (searchedMovies.contains(event.movie)) {
        searchedMovies = List.from(searchedMovies)
          ..remove(event.movie)
          ..insert(searchedIndex, event.movie.copyWith(isFavorite: false));
      }
      favoriteMovies.remove(event.movie);
    }

    emit(PopularMoviesState(
        castListStatus: state.castListStatus,
        popularMoviesStatus: state.popularMoviesStatus,
        favoriteMoviesStatus: state.favoriteMoviesStatus,
        searchedMoviesStatus: state.searchedMoviesStatus,
        popularMovies: popularMovies,
        favoriteMovies: favoriteMovies,
        searchedMovies: searchedMovies));
  }

  /// It uses the Emitter object to emit a new state based on the previous state.
  /// The _loadMyState function retrieves the favorite movies from local cache using the popularMoviesLocalDataSource object, and updates the popular movies list to include the favorite movies.
  /// The updated popular movies list is then emitted as the new state using the emit function. If there are no popular movies, the function emits an Error state with an error message "Server failure".
  void _loadMyState(LoadMyState event, Emitter<PopularMoviesState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    List<MovieModel> popularMovies = List.from(state.popularMovies);
    final favoriteMoviesFromCache =
        await popularMoviesLocalDataSource!.loadState();
    for (var i = 0; i < favoriteMoviesFromCache!.length; i++) {
      var favMovie = favoriteMoviesFromCache[i];
      var index = popularMovies.indexWhere((movie) => favMovie.id == movie.id);
      if (index != -1) {
        popularMovies[index] = favMovie;
      }
    }

    emit(PopularMoviesState(
        errorMessage: state.errorMessage,
        popularMoviesStatus: state.popularMoviesStatus,
        searchedMoviesStatus: state.searchedMoviesStatus,
        favoriteMoviesStatus: FavoriteMoviesStatus.success,
        searchedMovies: state.searchedMovies,
        favoriteMovies: favoriteMoviesFromCache,
        popularMovies: popularMovies,
        success: state.success));
  }

  // Return the proper message if the state is [Error]
  String _mapFailureToMessage({required Failure failure}) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case DeviceIsOfflineFailure:
        return deviceIsOfflineMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
