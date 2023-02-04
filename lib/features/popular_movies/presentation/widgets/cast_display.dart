import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// The CastDisplay class defines a stateless widget that takes in two required parameters: imageUrl and castActorName.
/// It displays an oval-shaped network image, with a placeholder and error widget, and a text label of the cast actor's name.
/// The imageUrl is concatenated with a base URL to form the complete image URL.
class CastDisplay extends StatelessWidget {
  const CastDisplay(
      {Key? key, required this.imageUrl, required this.castActorName})
      : super(key: key);

  final String? imageUrl;
  final String castActorName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              placeholder: (context, url) => const CircularProgressIndicator(),
              fit: BoxFit.cover,
              height: 100,
              width: 100,
              imageUrl: 'https://image.tmdb.org/t/p/original$imageUrl',
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Text(
            castActorName,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
