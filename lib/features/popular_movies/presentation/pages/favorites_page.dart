import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/widgets/loading_widget.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/widgets/message_display.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/widgets/movie_list_item.dart';
import '../bloc/popular_movies_bloc.dart';

/// This FavoritesPage widget displays the favorite movies using the BlocBuilder.
/// The BlocBuilder widget is connected to a PopularMoviesBloc and updates its state based on the PopularMoviesState.
/// If the state is Empty, it displays a MessageDisplay widget with a message "Empty". If the state is Loaded, it checks if the favoriteMovies list is empty or not.
/// If it's not empty, it returns a ListView that contains a list of MovieListItem widgets. If the list is empty, it displays a MessageDisplay widget with a message "Add favorite movies...".
/// If the state is Error, it displays a MessageDisplay widget with a message "Something went wrong!". In all other cases, it returns a Text widget that says "Failed".
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
      builder: (context, state) {
        if (state.favoriteMoviesStatus == FavoriteMoviesStatus.empty) {
          return const MessageDisplay(message: 'No data');
        } else if (state.favoriteMoviesStatus == FavoriteMoviesStatus.loading) {
          return const LoadingWidget();
        } else if (state.favoriteMoviesStatus == FavoriteMoviesStatus.success) {
          if (state.favoriteMovies.isNotEmpty) {
            return ListView.builder(
                itemCount: state.favoriteMovies.length,
                itemBuilder: (context, index) {
                  return MovieListItem(
                    movie: state.favoriteMovies[index],
                  );
                });
          } else {
            return const MessageDisplay(message: 'Add favorite movies...');
          }
        } else {
          return MessageDisplay(message: state.errorMessage);
        }
      },
    ));
  }
}
