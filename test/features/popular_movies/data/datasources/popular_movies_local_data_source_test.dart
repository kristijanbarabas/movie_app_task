import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_bloc/core/error/exceptions.dart';
import 'package:movie_app_bloc/features/popular_movies/data/datasources/popular_movies_local_data_source.dart';
import 'package:movie_app_bloc/features/popular_movies/data/models/popular_movies_model.dart';
import 'package:movie_app_bloc/mocks/mock_all.mocks.dart';

void main() {
  PopularMoviesLocalDataSourceImpl? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = PopularMoviesLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });

  group('getLastPopularMovies', () {
    final tFavoriteMovies = [
      MovieModel(
          id: 1,
          genreIds: const ["cached"],
          overview: "cached",
          posterPath: "cached",
          releaseDate: "cached",
          title: "cached",
          voteAverage: 10)
    ];
    test(
        'should return FavoriteMovies from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences!.getString(cachedFavoriteMovies))
          .thenReturn(json.encode(tFavoriteMovies));
      // act
      final result = await dataSource!.loadState();
      // assert
      verify(mockSharedPreferences!.getString('CACHED_FAVORITE_MOVIES'));
      expect(result, equals(tFavoriteMovies));
    });
    test('should throw a CacheException when there is no cached value', () {
      // arrange
      when(mockSharedPreferences!.getString(any)).thenReturn(null);
      // act
      // Not calling the method here, just storing it inside a call variable
      final call = dataSource!.loadState;
      // assert
      // Calling the method happens from a higher-order function passed.
      // This is needed to test if calling a method throws an exception.
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cachePopularMovies', () {
    final tMovieModel = MovieModel(
        id: 1,
        genreIds: const ["cached"],
        overview: "cached",
        posterPath: "cached",
        releaseDate: "cached",
        title: "cached",
        voteAverage: 10);
    List<MovieModel> tMoviesList = [tMovieModel];

    test('should call SharedPreferences to cache the data', () {
      //act
      dataSource!.saveState(tMoviesList);
      //assert
      final expectedJsonString = json.encode(tMoviesList);
      verify(mockSharedPreferences!
          .setString('CACHED_FAVORITE_MOVIES', expectedJsonString));
    });
  });
}
