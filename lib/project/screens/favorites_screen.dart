import 'package:flutter/material.dart';

import '../models/place.dart';
import '../widgets/place_card.dart';

class FavoritesScreen extends StatelessWidget {
  final void Function(Place place) onOpen;
  final void Function(Place place) onFavorite;

  const FavoritesScreen({
    super.key,
    required this.onOpen,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    List<Place> saved = places.where((p) => p.isFavorite).toList();

    if (saved.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text('No saved places yet'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: saved.length,
      itemBuilder: (context, index) {
        Place place = saved[index];
        return PlaceCard(
          place: place,
          onTap: () => onOpen(place),
          onFavorite: () => onFavorite(place),
        );
      },
    );
  }
}
