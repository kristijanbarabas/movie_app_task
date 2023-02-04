import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/exceptions.dart';
import '../models/popular_movies_model.dart';

/// The above code is defining an abstract class PopularMoviesRemoteDataSource that provides a blueprint for a data source for popular movie data.
/// The class defines three abstract methods:
/// getPopularMovies: Returns a Future that resolves to a PopularMoviesModel, given the pageNumber.
/// getCastList: Returns a Future that resolves to a list of CastListModel, given the movieId.
/// searchMovies: Returns a Future that resolves to a list of MovieModel, given the search query and an optional year.
/// It acts as an interface for other classes to implement, enforcing the requirement of these methods.
abstract class PopularMoviesRemoteDataSource {
  Future<PopularMoviesModel?>? getPopularMovies({required int pageNumber});
  Future<List<CastListModel?>?>? getCastList({required int movieId});
  Future<List<MovieModel>?>? getSearchedMovies(
      {required String query, int year = 0});
}

/// This is the implementation of the PopularMoviesRemoteDataSource abstract class.
/// The class implements 3 methods getPopularMovies, getCastList, and searchMovies.
/// Each method communicates with The Movie Database API using the Dio HTTP client to retrieve movie data.
/// Each method handles errors and exceptions that may occur during the API communication and returns either the data or null if an error occurs.
/// In case of specific errors like 422 (end of the list) or 500 (server error), custom exceptions are thrown.
///  The errors are also logged to the console for debugging purposes.
class PopularMoviesRemoteDataSourceImpl
    implements PopularMoviesRemoteDataSource {
  final Dio? client;

  PopularMoviesRemoteDataSourceImpl({required this.client});

  /// This code implements a function getPopularMovies in the abstract class PopularMoviesRemoteDataSource that retrieves the list of popular movies from an API using a REST client (client!).
  /// The function creates a URL for the API call by including the API key and page number.
  /// The function also sets the header for the request to {'Content-Type': 'application/json'} using the Options object.
  /// The function then sends a GET request to the API and retrieves the response.
  /// If the response status code is 200, the function converts the response data into a PopularMoviesModel object using the fromJson method and returns it.
  /// If the response status code is 422, the function throws an NoMatchingResultsException. For any other status code, the function throws a ServerException.
  /// In case of any error while making the API call, it returns null and prints the error message to the console.
  @override
  Future<PopularMoviesModel?>? getPopularMovies(
      {required int pageNumber}) async {
    const String apikey = '1c1e3c3dcae5f4fa73783288bdf04c17';
    String url =
        'https://api.themoviedb.org/3/movie/popular?api_key=$apikey&language=en-US&page=$pageNumber';
    final Options options =
        Options(headers: {'Content-Type': 'application/json'});
    // The try/catch bloc solves the http 422 error, when the user reaches the end of the popular movies list
    // You have reached the end! message is then displayed
    try {
      final response = await client!.get(url, options: options);
      if (response.statusCode == 200) {
        final data = PopularMoviesModel.fromJson(response.data);
        return data;
      } else if (response.statusCode == 422) {
        throw EndOfTheListException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// This implementation of the getCastList method retrieves the cast list for a movie with the given movieId from the TMDB API.
  /// The method first constructs the API key and the URL for the API endpoint. Then, it makes a GET request to the API using the client.get method.
  /// The function also sets the header for the request to {'Content-Type': 'application/json'} using the Options object.
  /// If the API returns a 200 status code, the method parses the response data and converts it into a list of CastListModel objects. Finally, it returns the list of cast models.
  /// If the API returns a different status code, it throws a ServerException. In case of any error while making the API call, it returns null and prints the error message to the console.
  @override
  Future<List<CastListModel?>?>? getCastList({required int movieId}) async {
    const String apikey = '1c1e3c3dcae5f4fa73783288bdf04c17';
    final Options options =
        Options(headers: {'Content-Type': 'application/json'});

    final response = await client!.get(
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apikey#',
        options: options);
    if (response.statusCode == 200) {
      var list = response.data['cast'] as List;
      List<CastListModel> castList = list
          .map((cast) => CastListModel(
                name: cast['name'],
                profilePath: cast['profile_path'],
              ))
          .toList();
      return castList;
    } else {
      throw ServerException();
    }
  }

  /// This implementation of the searchMovies method retrieves the list of movies with the given query and year from the TMDB API.
  ///  The function also sets the header for the request to {'Content-Type': 'application/json'} using the Options object.
  /// This function performs an HTTP GET request and returns a list of MovieModel objects if the response status code is 200 (OK).
  /// The call uses the [primary_release_year] query to filter the movies based on their release year
  /// If the response status code is not 200, it throws a custom ServerException.
  /// In case of any error while making the API call, it returns null and prints the error message to the console.
  @override
  Future<List<MovieModel>?>? getSearchedMovies(
      {required String query, int year = 0}) async {
    const String apikey = '1c1e3c3dcae5f4fa73783288bdf04c17';
    final Options options =
        Options(headers: {'Content-Type': 'application/json'});

    final response = await client!.get(
        "https://api.themoviedb.org/3/search/movie?api_key=$apikey&query=$query&primary_release_year=$year",
        options: options);

    if (response.statusCode == 200) {
      final popularMovies = PopularMoviesModel.fromJson(response.data);
      final movies = List<MovieModel>.from(popularMovies.results!);
      return movies;
    } else {
      throw ServerException();
    }
  }
}
