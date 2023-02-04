import 'package:flutter/material.dart';

// It takes a message string as a required constructor argument and displays the message in the center of the widget.
class MessageDisplay extends StatelessWidget {
  final String message;
  const MessageDisplay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
