import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/widgets/widgets.dart';
import '../../../../core/presentation/constants.dart';
import '../../data/models/popular_movies_model.dart';
import '../bloc/popular_movies_bloc.dart';

/// MovieListItem that displays information about a movie. The movie information is passed as a MovieModel object and is stored in the movie variable.
/// The widget displays the movie title, poster image (retrieved from a URL that uses the movie's posterPath field), and the movie's release date.
/// The movie's release date is formatted using DateFormat from the intl library.
/// The widget also contains a GestureDetector that, when tapped, navigates to a MovieDetailsPage that shows more information about the movie.
/// The widget also has a FavoriteIcon widget, which displays whether the movie is a favorite or not.
/// The MovieListItem widget is used within PopularMoviesDisplay to display a list of popular movies.
class MovieListItem extends StatelessWidget {
  const MovieListItem({Key? key, required this.movie}) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        'https://image.tmdb.org/t/p/original${movie.posterPath}';

    late String movieReleaseDate;
    // Check for format exceptions and return the proper response
    try {
      movieReleaseDate =
          DateFormat().add_yMMMd().format(DateTime.parse(movie.releaseDate!));
    } on FormatException {
      movieReleaseDate = 'No release date found';
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          context.read<PopularMoviesBloc>().add(GetCast(movieId: movie.id!));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MovieDetailsPage(
                        movie: movie,
                        imageUrl: imageUrl,
                      )));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              movie.title!,
              style: kHomePageTextStyle,
              textAlign: TextAlign.center,
            ),
            Stack(
              children: [
                Card(
                  shape: kCardShape,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      placeholder: (context, string) {
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: imageUrl,
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 1.5,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: FavoriteIcon(favoriteMovie: movie))
              ],
            ),
            Text(
              'Release date: $movieReleaseDate',
              style: kHomePageTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
