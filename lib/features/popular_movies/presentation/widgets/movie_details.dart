import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_bloc/core/presentation/constants.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/widgets/widgets.dart';
import '../../data/models/popular_movies_model.dart';

/// The MovieDetailsPage displays the movie data containing the movie poster, title, rating, synopsis and cast list
class MovieDetailsPage extends StatelessWidget {
  final MovieModel movie;
  final String imageUrl;

  const MovieDetailsPage({
    super.key,
    required this.movie,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is a SingleChildScrollView that allows the user to scroll through the whole screen
      body: SingleChildScrollView(
        // Top half of the screen containing the movie image, title and rating
        child: Column(
          children: [
            Stack(alignment: Alignment.center, children: [
              /// The movie poster image is shown as the top part of the screen
              /// Incase there is no image a Icon is shown instead
              ClipRRect(
                borderRadius: kDetailsImageBorderRadius,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const Positioned(
                top: 20,
                left: 5,
                child: BackIcon(),
              ),

              /// When the GestureDetector is tapped, it performs the following actions:
              /// It retrieves the PopularMoviesBloc from the context using context.read<PopularMoviesBloc>()
              /// It adds an event AddRemoveFavorite to the PopularMoviesBloc stream, passing in the current movie
              /// If the movie is not in the popularAndSearchedMovies list, the code will pop the current screen using Navigator.pop(context)
              /// Finally, it adds an event SaveMyState to the PopularMoviesBloc stream, passing in the current favoriteMovies list
              /// The child of the GestureDetector is a FavoriteIcon widget, which is used to display a heart icon indicating whether the movie is in the user's favorite list or not.
              BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                builder: (context, state) {
                  //
                  final List<MovieModel> popularAndSearchedMovies =
                      state.popularMovies + state.searchedMovies;
                  final List<MovieModel> listOfAllMovies = state.popularMovies +
                      state.searchedMovies +
                      state.favoriteMovies;
                  // If the movies id match, the isFavorite property is updated
                  final MovieModel movieInlist = listOfAllMovies
                      .firstWhere((movieModel) => movieModel.id == movie.id);
                  return Positioned(
                    top: 35,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        if (popularAndSearchedMovies.contains(movieInlist) ==
                            false) {
                          Navigator.pop(context);
                        }
                        context
                            .read<PopularMoviesBloc>()
                            .add(AddRemoveFavorite(movie: movieInlist));

                        // If a movie from the search list was added into the favorites list
                        // After we retrieve it from the cache if we remove it from the favorites it will throw a bad element error
                        // To avoid this error we navigate back from the screen after it's removed from the favorites list

                        context
                            .read<PopularMoviesBloc>()
                            .add(SaveMyState(state.favoriteMovies));
                      },
                      child: FavoriteIcon(favoriteMovie: movieInlist),
                    ),
                  );
                },
              ),
              // This container is used for displaying the title of the movie, and the rating
              // The text is displayed on a black semi-transparent background that allows the content to stand out and adds depth to the design.
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      MovieDetailsTitles(
                        alignment: Alignment.center,
                        title: movie.title!,
                      ),
                      MovieDetailsTitles(
                        alignment: Alignment.center,
                        title: movie.voteAverage!.toString(),
                      ),
                      _starRating(movie.voteAverage!)
                    ],
                  ),
                ),
              )
            ]),
            // Bottom half of the screen containing the synopsis and cast
            Column(
              children: [
                const MovieDetailsTitles(
                  title: 'Synopsis',
                  alignment: Alignment.centerLeft,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(movie.overview!,
                      textAlign: TextAlign.justify,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const Divider(
                  height: 5,
                  thickness: 1,
                ),
                const MovieDetailsTitles(
                  title: 'Cast',
                  alignment: Alignment.centerLeft,
                ),

                /// In this specific code, the widget being returned is a SizedBox that has a height and width that are a fraction of the height and width of the screen, respectively.
                /// Inside this SizedBox, there is a ListView.builder widget that is used to display a horizontal list of CastDisplay widgets.
                /// The number of items in the list is determined by the length of state.castList.
                /// The itemBuilder function is called for each item in the list, and it returns a CastDisplay widget, which takes imageUrl and castActorName as arguments.
                BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                  builder: (context, state) {
                    if (state.castListStatus == CastListStatus.empty) {
                      return const MessageDisplay(message: 'No data');
                    } else if (state.castListStatus == CastListStatus.loading) {
                      return const LoadingWidget();
                    } else if (state.castListStatus == CastListStatus.success) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.castList.length,
                            itemBuilder: (context, index) {
                              final String? imageUrl =
                                  state.castList[index]!.profilePath;
                              return CastDisplay(
                                imageUrl: imageUrl,
                                castActorName: state.castList[index]!.name!,
                              );
                            }),
                      );
                    } else {
                      return MessageDisplay(message: state.errorMessage);
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // This function is used to display star ratings based on a numerical input value rating.
  //The function returns a Text widget with different number of star characters (⭐) based on the input value.
  Text _starRating(num rating) {
    if (rating >= 8.5) {
      return Text(
        '⭐' * 5,
        style: kStars,
      );
    } else if (rating <= 8.4 && rating >= 6) {
      return Text(
        '⭐' * 4,
        style: kStars,
      );
    } else if (rating <= 5.9 && rating >= 4) {
      return Text(
        '⭐' * 3,
        style: kStars,
      );
    } else if (rating <= 3.9 && rating >= 2) {
      return Text(
        '⭐' * 2,
        style: kStars,
      );
    } else {
      return const Text(
        '⭐',
        style: kStars,
      );
    }
  }
}
