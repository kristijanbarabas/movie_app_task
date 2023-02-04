import 'package:movie_app_bloc/features/popular_movies/domain/entities/popular_movies.dart';

// These classes define models for the data being retrieved from an API for popular movies and cast information.
// PopularMoviesModel and MovieModel are subclasses of PopularMovies and Movie respectively.
// They have constructors and methods to convert from JSON to the model and vice versa, as well as from a Map to the model and vice versa.

/// MovieModel is a subclass of Movie
/// It has methods to convert from JSON to the model and vice versa.
class PopularMoviesModel extends PopularMovies {
  PopularMoviesModel(
      {super.page, super.results, super.castList, super.success});

  PopularMoviesModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    // return a list of MovieModel that is a subclass of Movie because the json data retrieved from the API is of type List<dynamic>
    if (json['results'] != null) {
      results = <MovieModel>[];
      json['results'].forEach((value) {
        results!.add(MovieModel.fromJson(value));
      });
    }

    success = true;
  }
  Map<String, dynamic> toJson() => {
        'page': page,
        'results': results,
        'success': success,
      };
}

/// MovieModel is a subclass of Movie
/// It has methods to convert from JSON to the model and vice versa, as well as from a Map to the model and vice versa.
class MovieModel extends Movie {
  MovieModel(
      {required super.overview,
      required super.posterPath,
      required super.genreIds,
      required super.id,
      required super.releaseDate,
      required super.title,
      required super.voteAverage,
      super.isFavorite = false});

  MovieModel copyWith({
    String? overview,
    String? posterPath,
    List? genreIds,
    int? id,
    String? releaseDate,
    String? title,
    num? voteAverage,
    bool? isFavorite,
  }) {
    return MovieModel(
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      genreIds: genreIds ?? this.genreIds,
      id: id ?? this.id,
      releaseDate: releaseDate ?? this.releaseDate,
      title: title ?? this.title,
      voteAverage: voteAverage ?? this.voteAverage,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
        overview: json['overview'],
        posterPath: json['poster_path'],
        genreIds: json['genre_ids'],
        id: json['id'],
        releaseDate: json['release_date'] != null || json['release_date'] != ""
            ? json['release_date']
            : "2007-08-17",
        title: json['title'],
        voteAverage: json['vote_average'],
        // IF NULL SET TO FALSE
        isFavorite: json['isFavorite'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'overview': overview,
      'poster_path': posterPath,
      'genre_ids': genreIds,
      'id': id,
      'release_date': releaseDate,
      'title': title,
      'vote_average': voteAverage,
      'isFavorite': isFavorite,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'overview': overview,
      'poster_path': posterPath,
      'genre_ids': genreIds,
      'id': id,
      'release_date': releaseDate,
      'title': title,
      'vote_average': voteAverage,
      'isFavorite': isFavorite,
    };
  }

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      overview: map['overview'] != null ? map['overview'] as String : null,
      posterPath:
          map['posterPath'] != null ? map['posterPath'] as String : null,
      genreIds: null,
      id: map['id'] != null ? map['id'] as int : null,
      releaseDate:
          map['releaseDate'] != null ? map['releaseDate'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      voteAverage:
          map['voteAverage'] != null ? map['voteAverage'] as num : null,
      isFavorite: map['isFavorite'] != null ? map['isFavorite'] as bool : null,
    );
  }
}

/// CastListModel is a subclass of CastList.
/// It has methods to convert from JSON to the model and vice versa, as well as from a Map to the model and vice versa.
class CastListModel extends CastList {
  CastListModel({
    required super.name,
    required super.profilePath,
  });

  CastListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePath = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'profile_path': profilePath};
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePath': profilePath,
    };
  }

  factory CastListModel.fromMap(Map<String, dynamic> map) {
    return CastListModel(
      name: map['name'] != null ? map['name'] as String : null,
      profilePath:
          map['profilePath'] != null ? map['profilePath'] as String : null,
    );
  }
}

// GenreModel is a subclass of Genre.
class GenreModel extends Genre {
  GenreModel({required super.id, required super.name, super.isPressed = false});
}
