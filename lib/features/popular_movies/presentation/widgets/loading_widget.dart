import 'package:flutter/material.dart';

/// This is a LoadingWidget class that creates a circular progress indicator in the center of the screen.
/// This widget is used as a placeholder when some data is being loaded asynchronously and is meant to be displayed to the user while they wait for the data to arrive.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
