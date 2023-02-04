import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/pages/home_page.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/pages/search_page.dart';
import '../../../../core/presentation/constants.dart';
import '../bloc/popular_movies_bloc.dart';
import '../widgets/widgets.dart';
import 'favorites_page.dart';

/// The AppBar has a leading Image of the logo, a centered title that displays the title of the selected page, and an action that displays a SearchIcon if the selected page is the first one.
/// The body displays the widget specified in the _pageDetails list of maps, where each map contains the pageName and title of the page. The default selected page index is set to 0, which is the first page.
/// The bottom navigation bar is a CurvedNavigationBar widget that displays two navigation items with their respective icons and labels. The navigation items correspond to the two pages specified in the _pageDetails list. The navigation bar updates the selected page index when the user taps on an item.
/// The initState method initializes a BLoC called popularMoviesBloc and adds the current state of the BLoC to it. The build method then uses the popularMoviesBloc in the body of the widget.
class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  static const id = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, dynamic>> _pageDetails = [
    {'pageName': const HomePage(), 'title': 'Popular Movies'},
    {'pageName': const FavoritesPage(), 'title': 'Favorite Movies'},
  ];
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  var _selectedPageIndex = 0;
  late PopularMoviesBloc popularMoviesBloc;
  @override
  void initState() {
    super.initState();
    popularMoviesBloc = context.read<PopularMoviesBloc>();
    popularMoviesBloc.add(LoadMyState(popularMoviesBloc.state));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // The TMDB image is shown as a logo
        leading: Image.asset('assets/images/logo.jpg'),
        centerTitle: true,
        title: Text(_pageDetails[_selectedPageIndex]['title']),
        actions: _selectedPageIndex == 0
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    // Pressing the search icon user is navigated to the SearchPage
                    onTap: () => Navigator.of(context).pushNamed(SearchPage.id),
                    child: const SearchIcon(),
                  ),
                )
              ]
            : null,
      ),
      // Here is the body of the page that changes depending on the _selectedPageIndex
      // It switches between HomePage and FavoritesPage
      body: _pageDetails[_selectedPageIndex]['pageName'],
      bottomNavigationBar: Theme(
        data: ThemeData(colorScheme: const ColorScheme.dark()),
        child: CurvedNavigationBar(
          backgroundColor: kAppColor,
          color: Colors.white,
          key: bottomNavigationKey,
          onTap: (index) {
            setState(() {
              _selectedPageIndex = index;
            });
          },
          items: [
            CurvedNavigationBarItem(
              labelStyle: kLabelStyle,
              label: _pageDetails[0]['title'],
              child: Icon(Icons.movie, size: 30, color: kAppColor),
            ),
            CurvedNavigationBarItem(
              labelStyle: kLabelStyle,
              label: _pageDetails[1]['title'],
              child: Icon(Icons.favorite, size: 30, color: kAppColor),
            )
          ],
        ),
      ),
    );
  }
}
