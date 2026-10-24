import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/place.dart';
import '../widgets/place_image.dart';
import '../widgets/tag_badge.dart';

class DetailScreen extends StatefulWidget {
  final Place place;

  const DetailScreen({super.key, required this.place});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int people = 1;

  void goBack([String? result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context, result);
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    Place place = widget.place;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goBack(),
        ),
        title: Text(place.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                Stack(
                  children: [
                    PlaceImage(
                      place: place,
                      width: double.infinity,
                      height: 260,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            place.isFavorite
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            setState(() {
                              place.isFavorite = !place.isFavorite;
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          place.country,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              place.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '\$${place.price.toInt()}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${place.rating}'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: place.tags
                            .map((tag) => TagBadge(text: tag))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        place.description,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => goBack(),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back to list'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (people > 1) {
                    setState(() {
                      people--;
                    });
                  }
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$people', style: const TextStyle(fontSize: 18)),
              IconButton(
                onPressed: () {
                  setState(() {
                    people++;
                  });
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    goBack('Booked $people person(s) to ${place.name}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Book Now  \$${(place.price * people).toInt()}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
