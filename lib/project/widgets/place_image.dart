import 'package:flutter/material.dart';

import '../models/place.dart';

class PlaceImage extends StatelessWidget {
  final Place place;
  final double? width;
  final double? height;

  const PlaceImage({super.key, required this.place, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      place.imagePath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return Container(
          width: width,
          height: height,
          color: place.color.withOpacity(0.3),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(width: width, height: height, color: place.color);
      },
    );
  }
}
