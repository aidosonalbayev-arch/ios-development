import 'package:flutter/material.dart';

import '../models/place.dart';

class PlaceImage extends StatelessWidget {
  final Place place;
  final double? width;
  final double? height;

  const PlaceImage({super.key, required this.place, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      place.imagePath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: place.color,
          child: const Icon(Icons.image, color: Colors.white, size: 44),
        );
      },
    );
  }
}
