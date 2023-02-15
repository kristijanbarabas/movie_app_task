import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/widgets/widgets.dart';
import '../../data/models/popular_movies_model.dart';
import '../bloc/popular_movies_bloc.dart';

/// PopularMoviesDisplay which displays a list of movies by using ListView.separated.
/// It receives two parameters - moviesList and success. moviesList is a list of MovieModel objects that are to be displayed in the list.
/// success is a boolean value that indicates if the movies have been successfully retrieved.
class PopularMoviesDisplay extends StatefulWidget {
  final List<MovieModel> moviesList;
  final bool success;

  const PopularMoviesDisplay(
      {super.key, required this.moviesList, required this.success});

  @override
  State<PopularMoviesDisplay> createState() => _PopularMoviesDisplayState();
}

class _PopularMoviesDisplayState extends State<PopularMoviesDisplay> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    /// ListView.separated widget is returned with the itemCount set to widget.moviesList.length + 1.
    /// The itemBuilder generates items for the list, and the separatorBuilder is set to display a divider between items.
    /// If the current index is less than the length of widget.moviesList, a MovieListItem widget is displayed for each movie.
    /// If widget.success is false, a MessageDisplay widget is displayed with the message "You have reached the end!".
    /// If widget.success is true, a LoadingWidget is displayed.
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        controller: controller,
        itemCount: widget.moviesList.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.moviesList.length) {
            final MovieModel movie = widget.moviesList[index];
            return MovieListItem(
              movie: movie,
            );
          } else if (widget.success == false) {
            return const MessageDisplay(message: 'You have reached the end!');
          } else {
            return const LoadingWidget();
          }
        });
  }

// The _onScroll method is called when the controller is scrolled.
//If the currentScroll position is equal to the maxScroll, the GetPopularMovies event is added to the PopularMoviesBloc.
  void _onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;
    if (currentScroll == maxScroll) {
      context.read<PopularMoviesBloc>().add(GetPopularMovies());
    }
  }

  // The dispose method disposes of the controller object.
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
