import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/place.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;
  bool isGrid = false;

  final List<String> titles = ['Explore', 'Favorites', 'Profile'];

  void toggleFavorite(Place place) {
    setState(() {
      place.isFavorite = !place.isFavorite;
    });
  }

  void refreshAll() {
    setState(() {});
  }

  void showResult(String? result) {
    setState(() {});
    if (!mounted || result == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }

  void openFromFeed(Place place) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(place: place)),
    );
    showResult(result);
  }

  void openFromFavorites(Place place) async {
    final result = await context.push<String>('/place/${place.id}');
    showResult(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
        actions: [
          if (currentIndex == 0)
            IconButton(
              tooltip: isGrid ? 'List view' : 'Grid view',
              icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
              onPressed: () {
                setState(() {
                  isGrid = !isGrid;
                });
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          FeedScreen(
            isGrid: isGrid,
            onOpen: openFromFeed,
            onFavorite: toggleFavorite,
            onChanged: refreshAll,
          ),
          FavoritesScreen(
            onOpen: openFromFavorites,
            onFavorite: toggleFavorite,
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Feed'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
