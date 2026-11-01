import 'package:flutter/material.dart';

import '../models/place.dart';
import 'place_image.dart';
import 'tag_badge.dart';

class PlaceListTile extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const PlaceListTile({
    super.key,
    required this.place,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: ClipOval(
          child: PlaceImage(place: place, width: 52, height: 52),
        ),
        title: Text(
          place.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TagBadge(text: place.tags.first),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 2),
                  Text(place.rating.toStringAsFixed(1)),
                ],
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${place.price.toInt()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              onPressed: onFavorite,
              icon: Icon(
                place.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: place.isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
