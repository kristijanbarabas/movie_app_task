import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_bloc/core/error/exceptions.dart';
import 'package:movie_app_bloc/features/popular_movies/data/datasources/popular_movies_remote_data_source.dart';
import 'package:movie_app_bloc/features/popular_movies/data/models/popular_movies_model.dart';
import 'package:movie_app_bloc/mocks/mock_all.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  PopularMoviesRemoteDataSourceImpl? dataSource;
  MockDio? mockHttpClient;

  setUp(() {
    mockHttpClient = MockDio();
    dataSource = PopularMoviesRemoteDataSourceImpl(client: mockHttpClient!);
  });
  const int tPageNumber = 1;
  const String apikey = '1c1e3c3dcae5f4fa73783288bdf04c17';
  const int currentPage = 1;

  const String popularMoviesUrl =
      'https://api.themoviedb.org/3/movie/popular?api_key=$apikey&language=en-US&page=$currentPage';

  const String path = '/movie/popular';
  final tPopularMovies =
      PopularMoviesModel.fromJson(json.decode(fixture('popular_movies.json')));

  test('should preform a GET request on a URL', () async {
    //assert
    when(mockHttpClient!.get(
      any,
    )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: path),
        data: fixture('popular_movies.json'),
        statusCode: 200));
    // act
    mockHttpClient!.get(popularMoviesUrl);
    //
    verify(mockHttpClient!.get(popularMoviesUrl));
  });
  group('getPopularMovies', () {
    test('should return PopularMovies when the response code is 200 ',
        () async {
// arrange
      when(mockHttpClient!.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: path),
              data: jsonDecode(fixture('popular_movies.json')),
              statusCode: 200));
      // act
      final result =
          await dataSource!.getPopularMovies(pageNumber: tPageNumber);
      // assert
      expect(result, equals(tPopularMovies));
    });
    test('return a null when there is an error', () async {
// arrange
      when(mockHttpClient!.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: path),
              data: null,
              statusCode: 404));
      // act
      final call = await dataSource!.getPopularMovies(pageNumber: tPageNumber);
      // assert
      expect(call, isNull);
    });
  });

  group('getCastList', () {
    List<CastListModel> tCastListModel = [
      CastListModel(name: "test", profilePath: "test")
    ];
    const int tMovieId = 100;
    test('should return CastList when the response code is 200 ', () async {
// arrange
      when(mockHttpClient!.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: path),
              data: jsonDecode(fixture('cast_list_response.json')),
              statusCode: 200));
      // act
      final result = await dataSource!.getCastList(movieId: tMovieId);
      // assert
      expect(result, equals(tCastListModel));
    });
    test('should throw a ServerException when response is 404 or other error',
        () async {
// arrange
      when(mockHttpClient!.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: path),
              data: null,
              statusCode: 404));
      // act
      final call = dataSource!.getCastList;
      // assert
      expect(() => call(movieId: tMovieId),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
  group('searchMovies', () {
    const String tQuery = 'test';
    final List<MovieModel> tList = [
      MovieModel(
          overview: 'test',
          posterPath: 'test',
          genreIds: null,
          id: 100,
          releaseDate: 'test',
          title: 'test',
          voteAverage: 10)
    ];
    test('should return list of MovieModel when the response code is 200 ',
        () async {
// arrange
      when(mockHttpClient!.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: path),
              data: jsonDecode(fixture('search_movies.json')),
              statusCode: 200));
      // act
      final result = await dataSource!.getSearchedMovies(query: tQuery);
      // assert
      expect(result, equals(tList));
    });
    test('should throw a ServerException when response is 404 or other error',
        () async {
// arrange
      when(mockHttpClient!.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: path),
              data: null,
              statusCode: 404));
      // act
      final call = dataSource!.getSearchedMovies;
      // assert
      expect(() => call(query: tQuery),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
