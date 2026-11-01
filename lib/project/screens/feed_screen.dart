import 'package:flutter/material.dart';

import '../models/place.dart';
import '../widgets/place_grid_card.dart';
import '../widgets/place_list_tile.dart';

class FeedScreen extends StatefulWidget {
  final bool isGrid;
  final void Function(Place place) onOpen;
  final void Function(Place place) onFavorite;
  final VoidCallback onChanged;

  const FeedScreen({
    super.key,
    required this.isGrid,
    required this.onOpen,
    required this.onFavorite,
    required this.onChanged,
  });

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Future<void> refreshCatalog() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    setState(() {
      places.insert(0, generateNewPlace());
    });
    widget.onChanged();
  }

  void deletePlace(Place place) {
    int index = places.indexOf(place);

    setState(() {
      places.removeAt(index);
    });
    widget.onChanged();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('${place.name} deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            int insertIndex = index;
            if (insertIndex > places.length) {
              insertIndex = places.length;
            }
            setState(() {
              places.insert(insertIndex, place);
            });
            widget.onChanged();
          },
        ),
      ),
    );
  }

  void resetCatalog() {
    setState(() {
      places.clear();
      places.addAll(seedPlaces());
    });
    widget.onChanged();
  }

  Widget buildDeleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Icon(Icons.delete, color: Colors.white, size: 32),
    );
  }

  Widget buildList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: places.length,
      separatorBuilder: (context, index) {
        return const Divider(height: 1, thickness: 0.5);
      },
      itemBuilder: (context, index) {
        Place place = places[index];
        return Dismissible(
          key: ValueKey(place.id),
          direction: DismissDirection.endToStart,
          background: buildDeleteBackground(),
          onDismissed: (direction) => deletePlace(place),
          child: PlaceListTile(
            place: place,
            onTap: () => widget.onOpen(place),
            onFavorite: () => widget.onFavorite(place),
          ),
        );
      },
    );
  }

  Widget buildGrid() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: places.length,
      itemBuilder: (context, index) {
        Place place = places[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Dismissible(
            key: ValueKey(place.id),
            direction: DismissDirection.endToStart,
            background: buildDeleteBackground(),
            onDismissed: (direction) => deletePlace(place),
            child: PlaceGridCard(
              place: place,
              onTap: () => widget.onOpen(place),
              onFavorite: () => widget.onFavorite(place),
            ),
          ),
        );
      },
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 90,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Catalog is Empty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: resetCatalog,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Catalog'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: refreshCatalog,
      child: widget.isGrid ? buildGrid() : buildList(),
    );
  }
}
