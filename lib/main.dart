import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_bloc/core/app_router/app_router.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/pages/tabs_page.dart';
import 'package:movie_app_bloc/injection_container.dart' as di;
import 'core/presentation/constants.dart';
import 'features/popular_movies/presentation/bloc/popular_movies_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The di.init() function is called to initialize the GetIt instance with various providers for the required services and dependencies.
  await di.init();
  runApp(MyApp(appRouter: AppRouter()));
}

// Root of the app
class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        // The PopularMoviesBloc instance is created inside a BlocProvider widget, which makes it accessible to its descendants in the widget tree.
        create: (context) =>
            di.sl<PopularMoviesBloc>()..add(GetPopularMovies()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: kAppTheme,
          // The MyApp widget also sets up the app theme and sets the home property to the TabsScreen widget.
          home: const TabsScreen(),
          // The onGenerateRoute property is set to the onGenerateRoute method of the AppRouter object, which is responsible for managing the navigation between pages in the app.
          onGenerateRoute: appRouter.onGenerateRoute,
        ));
  }
}
