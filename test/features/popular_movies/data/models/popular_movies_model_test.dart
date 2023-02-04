import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_bloc/features/popular_movies/data/models/popular_movies_model.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/entities/popular_movies.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tMovieModel = MovieModel(
      id: 1,
      genreIds: const [],
      overview: 'test',
      posterPath: 'test',
      releaseDate: 'test',
      title: 'test',
      voteAverage: 10);

  final tPopularMoviesModel = PopularMoviesModel(
    results: [tMovieModel],
    page: 1,
    success: true,
  );

  final tCastList = CastListModel(name: 'test', profilePath: 'test');

  final tGenreModel = GenreModel(name: 'test', id: 1, isPressed: true);

  test('PopularMoviesModel should be a subclass of PopularMovies entity',
      () async {
    expect(tPopularMoviesModel, isA<PopularMovies>());
  });

  test('MovieModel should be a subclass of Movie entity', () async {
    expect(tMovieModel, isA<Movie>());
  });

  test('CastListModel should be a subclass of CastList entity', () async {
    expect(tCastList, isA<CastList>());
  });
  test('GenreModel should be a subclass of Genre entity', () async {
    expect(tGenreModel, isA<Genre>());
  });

  group('fromJson', () {
    test('should return a valid PopularMoviesModel when the data is retrieved',
        () {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('popular_movies.json'));
      //act
      final result = PopularMoviesModel.fromJson(jsonMap);
      //assert
      expect(result, tPopularMoviesModel);
    });

    test('should return a valid CastListModel when the data is retrieved', () {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('cast_list.json'));
      //act
      final result = CastListModel.fromJson(jsonMap);
      //assert
      expect(result, tCastList);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // act
      final result = tPopularMoviesModel.toJson();
      // assert
      final expectedJsonMap = {
        'results': [tMovieModel],
        'page': 1,
        'totalPages': 100
      };
      expect(result, expectedJsonMap);
    });
  });
}
