import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../models/place.dart';
import 'catalog_screen.dart';
import 'place_detail_screen.dart';
import 'favorites_screen.dart';
import 'feed_screen.dart';
import 'notes_screen.dart';
import 'profile_screen.dart';

class RootScreen extends StatefulWidget {
  final int startIndex; // қай табтан басталады (0 = Feed, 2 = Shop)

  const RootScreen({super.key, this.startIndex = 0});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;
  bool isGrid = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.startIndex;
  }

  final List<String> titles = [
    'Explore',
    'Favorites',
    'Shop',
    'Notes',
    'Profile',
  ];

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
          // Себет өзгерсе, тек осы батырма қайта сызылады
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cart) {
              return IconButton(
                tooltip: 'Cart',
                icon: Badge(
                  label: Text('${cart.count}'),
                  isLabelVisible: cart.count > 0,
                  child: const Icon(Icons.shopping_cart),
                ),
                onPressed: () => context.push('/cart'),
              );
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
          const CatalogScreen(),
          const NotesScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
