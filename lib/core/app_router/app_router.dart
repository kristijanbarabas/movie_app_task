import 'package:flutter/material.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/pages/search_page.dart';
import '../../features/popular_movies/presentation/pages/tabs_page.dart';

/// Custom routing class called "AppRouter".
/// The "onGenerateRoute" method takes in a "RouteSettings" object and returns a "Route" object.
/// The method uses a switch statement to determine the route based on the "name" property of the "RouteSettings" object.
/// If the "name" property matches either "TabsScreen.id" or "SearchPage.id", the method returns a "MaterialPageRoute" with a corresponding screen being passed as the builder.
/// If the "name" does not match any cases, the method returns "null".
class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case TabsScreen.id:
        return MaterialPageRoute(builder: (_) => const TabsScreen());
      case SearchPage.id:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      default:
        return null;
    }
  }
}
