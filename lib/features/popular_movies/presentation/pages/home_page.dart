import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/widgets/widgets.dart';
import '../bloc/popular_movies_bloc.dart';

/// The HomePage widget contains a BlocBuilder widget which listens to a BLoC called PopularMoviesBloc and builds the UI based on its current state.
/// The BlocBuilder widget uses an anonymous function to determine what widget to display depending on the current state of PopularMoviesBloc.
/// If the state is Empty, it will display a MessageDisplay widget with message 'No data'.
/// If the state is Loading, it will display a CircularProgressIndicator widget.
/// If the state is Loaded, it will display a PopularMoviesDisplay widget with the success and moviesList parameters.
/// If the state is Error, it will display a MessageDisplay widget with the error message. If it fails to determine the state, it will display a Text widget with 'Failed!'.
class HomePage extends StatelessWidget {
  static const id = 'home_page';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
        builder: (context, state) {
          if (state.popularMoviesStatus == PopularMoviesStatus.empty) {
            return const MessageDisplay(
              message: '',
            );
          } else if (state.popularMoviesStatus == PopularMoviesStatus.loading) {
            return const CircularProgressIndicator();
          } else if (state.popularMoviesStatus == PopularMoviesStatus.success) {
            if (state.popularMovies.isEmpty) {
              return const MessageDisplay(
                  message:
                      'Something went wrong...\nCheck your internet connection!');
            } else {
              return PopularMoviesDisplay(
                success: state.success,
                moviesList: state.popularMovies,
              );
            }
          } else {
            return MessageDisplay(message: state.errorMessage);
          }
        },
      )),
    );
  }
}
