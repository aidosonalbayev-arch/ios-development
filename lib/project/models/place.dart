import 'package:flutter/material.dart';

class Place {
  static int _counter = 0;

  final int id;
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
  }) : id = ++_counter;
}

List<Place> seedPlaces() {
  return [
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
}

List<Place> places = seedPlaces();

int newPlaceCount = 0;

final List<String> newNames = [
  'Kolsai Lakes',
  'Cappadocia Balloons',
  'Santorini Sunset',
  'Tokyo Night Tour',
  'Paris Weekend',
  'Dubai Desert Safari',
];

final List<String> newCountries = [
  'Kazakhstan',
  'Turkey',
  'Greece',
  'Japan',
  'France',
  'UAE',
];

final List<String> newImages = [
  'assets/charyn.jpg',
  'assets/bigalmatylake.jpg',
  'assets/balibeach.jpg',
  'assets/stambulcitytour.jpg',
  'assets/swissalps.jpeg',
];

final List<Color> newColors = [
  Colors.green,
  Colors.orange,
  Colors.pink,
  Colors.cyan,
  Colors.brown,
  Colors.amber,
];

Place generateNewPlace() {
  int n = newPlaceCount;
  newPlaceCount++;

  int i = n % newNames.length;

  return Place(
    name: newNames[i],
    country: newCountries[i],
    price: (100 + (n * 137) % 900).toDouble(),
    rating: 4.0 + ((n * 3) % 10) / 10,
    description:
        'A fresh new trip added to the catalog. '
        'Check the details and book your place before it is gone.',
    imagePath: newImages[n % newImages.length],
    tags: ['New', 'Trending'],
    color: newColors[i],
  );
}

Place? findPlaceById(int id) {
  for (Place place in places) {
    if (place.id == id) {
      return place;
    }
  }
  return null;
}
