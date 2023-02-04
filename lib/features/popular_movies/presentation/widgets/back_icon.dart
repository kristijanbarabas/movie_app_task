import 'package:flutter/material.dart';
import '../../../../core/presentation/constants.dart';

/// The BackIcon listens for tap events and pops the current route from the Navigator, taking the user back to the previous screen.
class BackIcon extends StatelessWidget {
  const BackIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: 50,
          width: 50,
          decoration: kIconDecoration,
          child: const Icon(
            Icons.arrow_back,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
