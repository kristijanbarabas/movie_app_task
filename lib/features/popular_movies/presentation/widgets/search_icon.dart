import 'package:flutter/material.dart';

/// The SearchIcon widget is used to display a search icon on the UI.
/// The icon is displayed as a circle avatar with a black semi-transparent background and a white magnifying glass icon.
/// The purpose of the widget is to provide a visual representation of the search functionality in your application.
/// It is used as a button to trigger a search action when tapped and  redirecting the user to the SearchPage.
class SearchIcon extends StatelessWidget {
  const SearchIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black.withOpacity(0.2),
      child: const Icon(
        Icons.search,
        size: 35,
        color: Colors.white,
      ),
    );
  }
}
