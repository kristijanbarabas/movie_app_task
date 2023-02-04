import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_bloc/core/error/exceptions.dart';
import 'package:movie_app_bloc/core/error/failures.dart';
import 'package:movie_app_bloc/core/network/network_info.dart';
import 'package:movie_app_bloc/features/popular_movies/data/datasources/popular_movies_local_data_source.dart';
import 'package:movie_app_bloc/features/popular_movies/data/models/popular_movies_model.dart';
import 'package:movie_app_bloc/features/popular_movies/data/repositories/popular_movies_repository_impl.dart';
import 'package:movie_app_bloc/mocks/mock_all.mocks.dart';

class MockLocalDataSource extends Mock implements PopularMoviesLocalDataSource {
}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  PopularMoviesRepositoryImpl? repositoryImpl;
  MockPopularMoviesRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockPopularMoviesRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = PopularMoviesRepositoryImpl(
        remoteDataSource: mockRemoteDataSource!,
        localDataSource: mockLocalDataSource!,
        networkInfo: mockNetworkInfo!);
  });
  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  const int tPageNuber = 1;
  group('getPopularMovies', () {
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl!.getPopularMovies(pageNumber: tPageNuber);
      // assert
      verify(mockNetworkInfo!.isConnected);
    });
  });
  final tMovieModel = MovieModel(
      genreIds: const ['test'],
      id: 1,
      overview: 'test',
      posterPath: 'test',
      releaseDate: 'test',
      title: 'test',
      voteAverage: 10);
  final List<MovieModel> tMovieList = [tMovieModel];
  final tPopularMoviesModel =
      PopularMoviesModel(results: [tMovieModel], page: 1);
  const int tMovieid = 1;
  final List<CastListModel> tCastList = [
    CastListModel(name: 'test', profilePath: 'test')
  ];
  const String tQuery = 'test';
  runTestsOnline(() {
    setUp(() {
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return remote data when the getPopularMovies call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource!.getPopularMovies(pageNumber: tPageNuber))
          .thenAnswer((_) async => tPopularMoviesModel);
      // act
      final result =
          await repositoryImpl!.getPopularMovies(pageNumber: tPageNuber);
      // assert
      verify(mockRemoteDataSource!.getPopularMovies(pageNumber: tPageNuber));
      expect(result, equals(Right(tPopularMoviesModel)));
    });
    test(
        'should return remote data when the  getCastList call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource!.getCastList(movieId: tMovieid))
          .thenAnswer((_) async => tCastList);
      // act
      final result = await repositoryImpl!.getCastList(movieId: tMovieid);
      // assert
      verify(mockRemoteDataSource!.getCastList(movieId: tMovieid));
      expect(result, equals(Right(tCastList)));
    });
    test(
        'should return remote data when the  searchMovies call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource!.getSearchedMovies(query: tQuery))
          .thenAnswer((_) async => tMovieList);
      // act
      final result = await repositoryImpl!.getSearchedMovies(query: tQuery);
      // assert
      verify(mockRemoteDataSource!.getSearchedMovies(query: tQuery));
      expect(result, equals(Right(tMovieList)));
    });

    test(
        'should return server failure when the getPopularMovies call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource!.getPopularMovies(pageNumber: tPageNuber))
          .thenThrow(ServerException());
      // act
      final result =
          await repositoryImpl!.getPopularMovies(pageNumber: tPageNuber);

      // assert
      verify(mockRemoteDataSource!.getPopularMovies(pageNumber: tPageNuber));
      expect(result, equals(Left(ServerFailure())));
    });
    test(
        'should return server failure when the getCastList call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource!.getCastList(movieId: tMovieid))
          .thenThrow(ServerException());
      // act
      final result = await repositoryImpl!.getCastList(movieId: tMovieid);

      // assert
      verify(mockRemoteDataSource!.getCastList(movieId: tMovieid));
      expect(result, equals(Left(ServerFailure())));
    });
    test(
        'should return server failure when the searchMovies call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource!.getSearchedMovies(query: tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repositoryImpl!.getSearchedMovies(query: tQuery);

      // assert
      verify(mockRemoteDataSource!.getSearchedMovies(query: tQuery));
      expect(result, equals(Left(ServerFailure())));
    });
  });

  runTestsOffline(() {
    setUp(() {
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
    });
    test(
        'should return DeviceIsOffline when the device is not connected to a network',
        () async {
      // act
      final result =
          await repositoryImpl!.getPopularMovies(pageNumber: tPageNuber);
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, equals(Left(DeviceIsOfflineFailure())));
    });
  });
}
