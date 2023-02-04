import 'package:flutter/material.dart';
import 'package:movie_app_bloc/core/presentation/constants.dart';
import '../../data/models/popular_movies_model.dart';

/// FavoriteIcon takes in a required favoriteMovie object and displays an icon indicating whether the movie is a favorite or not.
/// Depending on the state of favoriteMovies.isFavorite property a Icon widget is displayed
/// If favoriteMovie.isFavorite is true an Icon widget with a favorite icon is displayed or if it's false an Icon widget with a favorite_outline icon.
/// The Icon widget is colored white if  favoriteMovie.isFavorite is false or red if it's true.
class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({
    Key? key,
    required this.favoriteMovie,
  }) : super(key: key);

  final MovieModel favoriteMovie;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 50,
        decoration: kIconDecoration,
        child: favoriteMovie.isFavorite!
            ? const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 40,
              )
            : const Icon(
                Icons.favorite_outline,
                color: Colors.white,
                size: 40,
              ));
  }
}
