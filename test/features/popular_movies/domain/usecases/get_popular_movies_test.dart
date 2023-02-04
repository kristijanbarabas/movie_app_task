import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_bloc/features/popular_movies/data/models/popular_movies_model.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/entities/popular_movies.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/repositories/popular_movies_repository.dart';
import 'package:movie_app_bloc/features/popular_movies/domain/usecases/get_popular_movies.dart';

class MockPopularMoviesRepository extends Mock
    implements PopularMoviesRepository {}

void main() {
  GetPopularMoviesUseCase? usecase;
  GetCastListUseCase? getCastListUseCase;
  GetSearchUseCase? getSearchUseCase;
  MockPopularMoviesRepository? mockPopularMoviesRepository;

  setUp(() {
    mockPopularMoviesRepository = MockPopularMoviesRepository();

    usecase = GetPopularMoviesUseCase(mockPopularMoviesRepository!);
    getCastListUseCase = GetCastListUseCase(mockPopularMoviesRepository);
    getSearchUseCase = GetSearchUseCase(mockPopularMoviesRepository);
  });
  const int tPageNumber = 1;
  final List<MovieModel> tMovies = [
    MovieModel(
        isFavorite: false,
        id: 1,
        genreIds: const ['test'],
        overview: 'test',
        posterPath: 'test',
        releaseDate: 'test',
        title: 'test',
        voteAverage: 10)
  ];
  final tPopularMovies = PopularMovies(
    results: tMovies,
    page: 1,
  );

  const int tMovieId = 1;
  List<CastListModel> tCastListModel = [
    CastListModel(name: "test", profilePath: "test")
  ];

  const String tQuery = 'test';

  test('should get popular movies from the repository', () async {
    // "On the fly" implementation of the Repository using the Mockito package.
    // When getPopularMovies is called always answer with
    // the Right "side" of Either containing a test PopularMovies object.
    when(mockPopularMoviesRepository!.getPopularMovies(pageNumber: tPageNumber))
        .thenAnswer((_) async => Right(tPopularMovies));
    // The "act" phase of the test. Call the not-yet-existent method.
    final result = await usecase!.call(const Params(pageNumber: 1));
    // UseCase should simply return whatever was returned from the Repository
    expect(result, Right(tPopularMovies));
    // Verify that the method has been called on the Repository
    verify(
        mockPopularMoviesRepository!.getPopularMovies(pageNumber: tPageNumber));
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockPopularMoviesRepository);
  });
  test('should get cast list from the repository', () async {
    when(mockPopularMoviesRepository!.getCastList(movieId: tMovieId))
        .thenAnswer((_) async => Right(tCastListModel));

    final result =
        await getCastListUseCase!.call(const Params(movieId: tMovieId));

    expect(result, Right(tCastListModel));

    verify(mockPopularMoviesRepository!.getCastList(movieId: tMovieId));

    verifyNoMoreInteractions(mockPopularMoviesRepository);
  });
  test('should get the searched movies results from the repository', () async {
    when(mockPopularMoviesRepository!
            .getSearchedMovies(query: tQuery, year: 2022))
        .thenAnswer((_) async => Right(tMovies));

    final result =
        await getSearchUseCase!.call(const Params(query: tQuery, year: 2022));

    expect(result, Right(tMovies));

    verify(mockPopularMoviesRepository!
        .getSearchedMovies(query: tQuery, year: 2022));

    verifyNoMoreInteractions(mockPopularMoviesRepository);
  });
}
