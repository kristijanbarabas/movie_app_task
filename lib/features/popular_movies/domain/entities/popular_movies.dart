import 'package:equatable/equatable.dart';

/// These are the application's entities and classes related to popular movies.
/// The PopularMovies class contains the details of popular movies
/// The Movie class contains the details of a single movie
/// The CastList class contains the details of cast members
/// The Genre class contains the details of a movie genre

class PopularMovies extends Equatable {
  // The 'num' type can be both a 'double' and an 'int' to avoid wrong data type related errors
  num? page;
  List<Movie>? results;
  bool? success;

  List<CastList>? castList;

  PopularMovies({this.page, this.results, this.castList, this.success});

  @override
  List<Object?> get props => [page, results, castList, success];
}

class Movie extends Equatable {
  final String? overview;
  final String? posterPath;
  final List? genreIds;
  final int? id;
  final String? releaseDate;
  final String? title;
  final num? voteAverage;
  bool? isFavorite;

  Movie(
      {required this.overview,
      required this.posterPath,
      required this.genreIds,
      required this.id,
      required this.releaseDate,
      required this.title,
      required this.voteAverage,
      required this.isFavorite});

  @override
  List<Object?> get props => [
        overview,
        posterPath,
        genreIds,
        id,
        releaseDate,
        title,
        voteAverage,
        isFavorite
      ];
}

class CastList extends Equatable {
  String? name;
  String? profilePath;
  CastList({
    this.name,
    this.profilePath,
  });

  @override
  List<Object?> get props => [
        name,
        profilePath,
      ];
}

class Genre extends Equatable {
  final int id;
  final String name;
  bool isPressed;

  Genre({required this.id, required this.name, this.isPressed = false});

  @override
  List<Object?> get props => [id, name, isPressed];
}
