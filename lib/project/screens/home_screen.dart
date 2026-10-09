import 'package:flutter/material.dart';

import '../models/place.dart';
import '../widgets/place_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    List<Place> shownPlaces = places;
    if (showOnlyFavorites) {
      shownPlaces = places.where((p) => p.isFavorite).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Explore'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: !showOnlyFavorites,
                  onSelected: (value) {
                    setState(() {
                      showOnlyFavorites = false;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Favorites'),
                  selected: showOnlyFavorites,
                  onSelected: (value) {
                    setState(() {
                      showOnlyFavorites = true;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: shownPlaces.isEmpty
                ? const Center(child: Text('No favorites yet'))
                : ListView.builder(
                    itemCount: shownPlaces.length,
                    itemBuilder: (context, index) {
                      Place place = shownPlaces[index];
                      return PlaceCard(
                        place: place,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(place: place),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        onFavorite: () {
                          setState(() {
                            place.isFavorite = !place.isFavorite;
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
