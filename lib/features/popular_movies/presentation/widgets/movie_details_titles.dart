import 'package:flutter/material.dart';

/// This class MovieDetailsTitles creates a text widget to display a title in a movie details page.
/// It takes in two required parameters: title which is the text to be displayed and alignment which determines the position of the text.
/// It returns a widget that is aligned according to the given alignment and has a text style of font size 28 and bold.
class MovieDetailsTitles extends StatelessWidget {
  final String title;
  final Alignment alignment;

  const MovieDetailsTitles({
    Key? key,
    required this.title,
    required this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Align(
        alignment: alignment,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
