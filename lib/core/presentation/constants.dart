import 'package:flutter/material.dart';

// This file contains some of the repeatable styling code used in the widgets for easier readability

// Style for the text in the HomePage widget
const TextStyle kHomePageTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

// Size of the stars in the movie details screen
const TextStyle kStars = TextStyle(fontSize: 20);

// Decoration for the Favorite and back icon
BoxDecoration kIconDecoration = BoxDecoration(
  shape: BoxShape.circle,
  color: Colors.black.withOpacity(0.5),
);

const TextStyle kLabelStyle =
    TextStyle(color: Colors.black, fontFamily: 'Roboto');

// Card widget shape used
RoundedRectangleBorder kCardShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

// Movie details image border styl
const BorderRadius kDetailsImageBorderRadius = BorderRadius.only(
    bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30));

// Search field border
const OutlineInputBorder kSearchOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(width: 2, color: Colors.white));

// Main color of the app
Color kAppColor = const Color.fromARGB(255, 3, 37, 65);

// The app theme
ThemeData kAppTheme = ThemeData.dark().copyWith(
  toggleableActiveColor: Colors.blue,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white))),
  focusColor: Colors.red,
  highlightColor: Colors.red,
  backgroundColor: kAppColor,
  scaffoldBackgroundColor: kAppColor,
  appBarTheme: AppBarTheme(backgroundColor: kAppColor),
);
