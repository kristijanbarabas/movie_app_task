import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_bloc/core/presentation/constants.dart';
import 'package:movie_app_bloc/features/popular_movies/data/models/popular_movies_model.dart';
import 'package:movie_app_bloc/features/popular_movies/presentation/widgets/widgets.dart';
import '../bloc/popular_movies_bloc.dart';

/// SearchPage is a screen for searching movies.
///  The screen has a text field for entering the movie title to search, an expansion tile for filters, and a switch to select the year.
/// The text field has a search icon and an input decoration with a hint text and enabled and focused borders.
/// The state object initializes the PopularMoviesBloc and has a TextEditingController for the text field, a DateTime object to store the selected year, and a list of movie genres.
/// There is also a list selectedGenres to store the selected genres.
/// The build method returns a scaffold with an app bar and a column that contains the text field and the expansion tile.
/// The expansion tile has a year picker and a list of movie genres that can be selected as filters.
/// The state object has methods _selectYear for selecting the year and _onSearchEvent and _onSearchEventWithFilters to trigger the search for movies with or without filters.
class SearchPage extends StatefulWidget {
  static const id = 'search_page';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  late String inputString = '';
  DateTime selectedYear = DateTime.now();
  bool yearIsSelected = false;

  @override
  void initState() {
    super.initState();
  }

  // List of movie genres as listed in the [TMDB] documentation
  // Each item in the list contains a bool isPressed that is set to default
  // When we press on the desired filter from the filter list we change the value of the bool to true and add it to the selectedGenres list
  List<GenreModel> movieGenres = [
    GenreModel(id: 28, name: 'Action'),
    GenreModel(id: 12, name: 'Adventure'),
    GenreModel(id: 16, name: 'Animation'),
    GenreModel(id: 35, name: 'Comedy'),
    GenreModel(id: 80, name: 'Crime'),
    GenreModel(id: 99, name: 'Documentary'),
    GenreModel(id: 18, name: 'Drama'),
    GenreModel(id: 10751, name: 'Family'),
    GenreModel(id: 14, name: 'Fantasy'),
    GenreModel(id: 36, name: 'History'),
    GenreModel(id: 27, name: 'Horror'),
    GenreModel(id: 10402, name: 'Music'),
    GenreModel(id: 9648, name: 'Mystery'),
    GenreModel(id: 10749, name: 'Romance'),
    GenreModel(id: 878, name: 'Science Fiction'),
    GenreModel(id: 10770, name: 'TV Movie'),
    GenreModel(id: 53, name: 'Thriller'),
    GenreModel(id: 10752, name: 'War'),
    GenreModel(id: 37, name: 'Western')
  ];

  // Llist that will contain the genres that have the isPressed value set to true
  List selectedGenres = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('Search'),
        ),
        body: Column(
          children: [
            // Part of the screen that contains the TextField where the query (title of the movie) is inputed
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        // Search Icon is wrapped inside a GestureDetector so the SearchForMovies event can be triggered
                        suffixIcon: GestureDetector(
                            onTap: () {
                              // Check if a year is selected for filtering
                              _searchEvent();
                              // To hide the keyboard if the event is triggered
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: SearchIcon(),
                            )),
                        hintText: 'Search movie by title...',
                        enabledBorder: kSearchOutlineInputBorder,
                        focusedBorder: kSearchOutlineInputBorder),
                    // Here the inputString is updated with the new value from the TextField
                    onChanged: (value) {
                      inputString = value;
                    },
                    onSubmitted: (_) =>
                        // Check if a year is selected for filtering
                        _searchEvent(),
                  ),
                ),
                // Expansion tile that contains the year and genre filters
                ExpansionTile(
                  title: const Text(
                    'Filters',
                    style: TextStyle(fontSize: 20),
                  ),
                  children: [
                    // Year Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                            value: yearIsSelected,
                            onChanged: (value) {
                              setState(() {
                                yearIsSelected = value;
                              });
                            }),
                        GestureDetector(
                          onTap: () => _selectYear(context),
                          child: Row(
                            children: [
                              Text(
                                'Selected year: ${selectedYear.year.toString()}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Icon(
                                Icons.calendar_month,
                                size: 30,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    // Genres picker
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movieGenres.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      backgroundColor:
                                          movieGenres[index].isPressed
                                              ? Colors.blue
                                              : Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      // Toggle the isPressed value using the bang [!] operator, by default it's set to false
                                      movieGenres[index].isPressed =
                                          !movieGenres[index].isPressed;
                                    });
                                    if (movieGenres[index].isPressed == true) {
                                      selectedGenres.add(movieGenres[index].id);
                                    } else {
                                      selectedGenres
                                          .remove(movieGenres[index].id);
                                    }
                                  },
                                  child: Text(
                                    movieGenres[index].name,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  )),
                            );
                          }),
                    ),
                    // Rreset filters
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Reset filters',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () => _clearFilter(),
                              style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50)))),
                              child: const Icon(
                                Icons.clear,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),

            // Part of the screen that shows the list of the movies fetched from the SearchForMovies event
            // If the search has not been triggered the user is displayed a message: Start searching!
            // While the data is being fetched the user is shown a LoadingWidget
            // If the data is fetched it is displayed in a ListView
            // On Error the user is displayed a message containing the error
            BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
              builder: (context, state) {
                List<MovieModel> movies = state.searchedMovies;
                if (state.searchedMoviesStatus == SearchedMoviesStatus.empty) {
                  return const MessageDisplay(message: 'Start searching!');
                } else if (state.searchedMoviesStatus ==
                    SearchedMoviesStatus.loading) {
                  return const Expanded(child: LoadingWidget());
                } else if (state.searchedMoviesStatus ==
                    SearchedMoviesStatus.success) {
                  if (movies.isEmpty) {
                    return const MessageDisplay(
                        message: 'No results matching your criteria...');
                  } else {
                    return Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return MovieListItem(
                              movie: movie,
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: movies.length),
                    );
                  }
                } else {
                  return MessageDisplay(message: state.errorMessage);
                }
              },
            )
          ],
        ));
  }

  // This function opens the Dialog window that allows the user to select a year for filtering
  void _selectYear(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: kAppColor,
          title: const Text(
            "Select movie release year:",
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 2,
            child: YearPicker(
              // [firstDate] According to Google the oldest movie was released in 1888 and the lastDate is the current date
              firstDate: DateTime(1888),
              lastDate: DateTime.now(),
              selectedDate: selectedYear,
              onChanged: (DateTime dateTime) {
                setState(() {
                  selectedYear = dateTime;
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  // Reset the filters to starting values
  void _clearFilter() {
    setState(() {
      movieGenres.any((movie) => movie.isPressed = false);
      yearIsSelected = false;
    });
  }

// Function that triggers the SearchForMovies event when the year is not selected
  void _onSearchEvent(TextEditingController controller, String inputString) {
    controller.clear();
    context.read<PopularMoviesBloc>().add(
        GetSearchedMovies(query: inputString, selectedGenres: selectedGenres));
  }

// Function that triggers the SearchForMovies event when the year is selected
  void _onSearchEventWithFilters(TextEditingController controller,
      String inputString, int year, bool yearIsSelected) {
    controller.clear();
    context.read<PopularMoviesBloc>().add(GetSearchedMovies(
        query: inputString,
        year: year,
        yearIsSelected: yearIsSelected,
        selectedGenres: selectedGenres));
  }

  // Function triggers the search event depedning if the year is selected or not
  void _searchEvent() {
    if (yearIsSelected == true) {
      _onSearchEventWithFilters(
          controller, inputString, selectedYear.year, yearIsSelected);
    } else {
      _onSearchEvent(controller, inputString);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
