import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_bloc/features/popular_movies/data/datasources/popular_movies_local_data_source.dart';
import 'package:movie_app_bloc/features/popular_movies/data/models/popular_movies_model.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/bloc/popular_movies_bloc.dart';

class MockGetPopularMovies extends Mock implements GetPopularMoviesUseCase {}

class MockGetCastListUseCase extends Mock implements GetCastListUseCase {}

class MockGetSearchUseCase extends Mock implements GetSearchUseCase {}

class MockPopularMoviesLocalDataSource extends Mock
    implements PopularMoviesLocalDataSource {}

void main() {
  PopularMoviesBloc? bloc;
  MockGetPopularMovies? mockGetPopularMovies;
  MockGetCastListUseCase? mockGetCastListUseCase;
  MockGetSearchUseCase? mockGetSearchUseCase;
  MockPopularMoviesLocalDataSource? localDataSource;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetCastListUseCase = MockGetCastListUseCase();
    mockGetSearchUseCase = MockGetSearchUseCase();
    bloc = PopularMoviesBloc(
        getPopularMoviesData: mockGetPopularMovies,
        getCastListUseCase: mockGetCastListUseCase,
        popularMoviesLocalDataSource: localDataSource,
        getSearchUseCase: mockGetSearchUseCase);
  });
  test('initialState should be PopularMoviesInitial', () {
    //
    expect(bloc!.state, equals(PopularMoviesInitial()));
  });
  group('GetPopularMovies', () {
    const int tPageNumber = 1;
    final MovieModel tMovieModel = MovieModel(
        id: 1,
        genreIds: const ['cached'],
        overview: "cached",
        posterPath: "cached",
        releaseDate: "cached",
        title: "cached",
        voteAverage: 10);

    final List<MovieModel> tListMovieModel = [tMovieModel];
    final tPopularMoviesModel = PopularMoviesModel(
      page: 1,
      results: [tMovieModel],
    );
    final tTestModel = PopularMoviesModel(
      page: 1,
      results: const [],
    );
    List<CastListModel> tCastListModel = [
      CastListModel(name: "test", profilePath: "test")
    ];
    const int tMovieId = 100;
    const String tQuery = 'test';
    test('should get data from the getPopularMovies use case', () async {
      //arrange
      when(mockGetPopularMovies!(any))
          .thenAnswer((_) async => Right(tPopularMoviesModel));
      // act
      bloc!.add(GetPopularMovies());
      await untilCalled(mockGetPopularMovies!(any));
      // assert
      verify(mockGetPopularMovies!(const Params(pageNumber: tPageNumber)));
    });
    test('should get data from the getCastList use case', () async {
      //arrange
      when(mockGetSearchUseCase!(any))
          .thenAnswer((_) async => Right(tListMovieModel));
      // act
      bloc!.add(const GetCast(movieId: tMovieId));
      await untilCalled(mockGetCastListUseCase!(any));
      // assert
      verify(mockGetCastListUseCase!(const Params(movieId: tMovieId)));
    });
    test('should get data from the getSearchMovies use case', () async {
      //arrange
      when(mockGetCastListUseCase!(any))
          .thenAnswer((_) async => Right(tCastListModel));
      // act
      bloc!.add(const GetSearchedMovies(query: tQuery));
      await untilCalled(mockGetSearchUseCase!(any));
      // assert
      verify(mockGetSearchUseCase!(const Params(query: tQuery)));
    });
  });
}
