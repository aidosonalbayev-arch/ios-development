import 'package:flutter/material.dart';

import '../models/place.dart';
import '../widgets/place_card.dart';

class FeedScreen extends StatelessWidget {
  final void Function(Place place) onOpen;
  final void Function(Place place) onFavorite;

  const FeedScreen({super.key, required this.onOpen, required this.onFavorite});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: places.length,
      itemBuilder: (context, index) {
        Place place = places[index];
        return PlaceCard(
          place: place,
          onTap: () => onOpen(place),
          onFavorite: () => onFavorite(place),
        );
      },
    );
  }
}
