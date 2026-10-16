import 'package:flutter/material.dart';

class Place {
  final String name;
  final String country;
  final double price;
  final double rating;
  final String description;
  final String imagePath;
  final List<String> tags;
  final Color color;
  bool isFavorite;

  Place({
    required this.name,
    required this.country,
    required this.price,
    required this.rating,
    required this.description,
    required this.imagePath,
    required this.tags,
    required this.color,
    this.isFavorite = false,
  });
}

List<Place> places = [
  Place(
    name: 'Charyn Canyon',
    country: 'Kazakhstan',
    price: 80,
    rating: 4.8,
    description:
        'Charyn Canyon is one of the most beautiful places in Kazakhstan. '
        'You can walk along the Valley of Castles and see red rocks.',
    imagePath: 'assets/charyn.jpg',
    tags: ['Nature', 'Hiking', 'Photo', 'Weekend'],
    color: Colors.deepOrange,
  ),
  Place(
    name: 'Big Almaty Lake',
    country: 'Kazakhstan',
    price: 40,
    rating: 4.7,
    description:
        'A turquoise mountain lake near Almaty. '
        'Great place for a short trip and for nice photos.',
    imagePath: 'assets/bigalmatylake.jpg',
    tags: ['Lake', 'Mountains', 'Photo'],
    color: Colors.blue,
  ),
  Place(
    name: 'Bali Beach',
    country: 'Indonesia',
    price: 950,
    rating: 4.9,
    description:
        'Warm sea, surfing and tasty food. '
        'Bali is a perfect place to relax and enjoy the sun.',
    imagePath: 'assets/balibeach.jpg',
    tags: ['Beach', 'Surfing', 'Relax', 'Sea', 'Summer'],
    color: Colors.teal,
  ),
  Place(
    name: 'Istanbul City Tour',
    country: 'Turkey',
    price: 600,
    rating: 4.6,
    description:
        'Visit Hagia Sophia, the Blue Mosque and the Grand Bazaar. '
        'A city where Europe meets Asia.',
    imagePath: 'assets/stambulcitytour.jpg',
    tags: ['City', 'History', 'Food'],
    color: Colors.purple,
  ),
  Place(
    name: 'Swiss Alps',
    country: 'Switzerland',
    price: 1500,
    rating: 4.9,
    description:
        'Snowy mountains, clean air and train trips with amazing views.',
    tags: ['Mountains', 'Ski', 'Winter', 'Luxury'],
    color: Colors.indigo,
    imagePath: 'assets/swissalps.jpeg',
  ),
];
