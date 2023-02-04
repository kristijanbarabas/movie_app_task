import 'dart:convert';

import 'package:movie_app_bloc/core/error/exceptions.dart';
import 'package:movie_app_bloc/features/popular_movies/data/models/popular_movies_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The abstract class PopularMoviesLocalDataSource defines two methods saveState() & loadState()
abstract class PopularMoviesLocalDataSource {
  /// Saves the list of favorite movies as [List<MovieModel>]
  Future<void> saveState(List<MovieModel> favoriteMovies);

  /// Gets the cached [List<MovieModel>] that contains the list of favorite movies
  /// Throws [CacheException] if no cached data is present.
  Future<List<MovieModel>>? loadState();
}

///  This is the cache key.
const String cachedFavoriteMovies = 'CACHED_FAVORITE_MOVIES';

/// The implementation PopularMoviesLocalDataSourceImpl saves and loads favorite movie information as a list of MovieModel objects to and from shared preferences using JSON encoding and decoding.
/// If no saved state is found, a CacheException is thrown.
class PopularMoviesLocalDataSourceImpl implements PopularMoviesLocalDataSource {
  final SharedPreferences sharedPreferences;

  const PopularMoviesLocalDataSourceImpl({required this.sharedPreferences});

  /// Function that uses the SharedPreferences package to store a list of MovieModel objects as a JSON string in the device's local storage.
  /// The jsonEncode function from the dart:convert library is used to convert the list of MovieModel objects into a JSON string, which is then stored in the shared preferences with a key named cachedFavoriteMovies.
  /// The Future function returns void and is async, meaning it may take some time to complete and should be executed asynchronously to avoid blocking the main thread.
  @override
  Future<void> saveState(List<MovieModel> favoriteMovies) async {
    sharedPreferences.setString(
        cachedFavoriteMovies, jsonEncode(favoriteMovies));
  }

  /// This function retrieves a previously saved list of MovieModel objects from the device's shared preferences storage.
  /// The function uses the SharedPreferences.getInstance() method to get an instance of SharedPreferences object.
  /// Then, it uses the getString method to retrieve the string value stored in the shared preferences using the key cachedFavoriteMovies.
  /// If a value is found for the specified key, it is decoded from JSON using jsonDecode and converted into a list of MovieModel objects using the map and toList methods.
  /// The list of MovieModel objects is then returned.
  /// If no value is found, the function throws a CacheException.
  @override
  Future<List<MovieModel>> loadState() async {
    final savedState = sharedPreferences.getString(cachedFavoriteMovies);
    if (savedState != null) {
      final List state = jsonDecode(savedState);
      final favoriteMovies = state.map((e) => MovieModel.fromJson(e)).toList();
      return favoriteMovies;
    } else {
      throw CacheException();
    }
  }
}
