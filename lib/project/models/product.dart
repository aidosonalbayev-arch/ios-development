import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final IconData icon;
  final Color color;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.color,
  });
}

const List<Product> products = [
  Product(
    id: 1,
    name: 'Travel Backpack',
    category: 'Bags',
    price: 45,
    icon: Icons.backpack,
    color: Colors.deepOrange,
  ),
  Product(
    id: 2,
    name: 'Neck Pillow',
    category: 'Comfort',
    price: 18,
    icon: Icons.hotel,
    color: Colors.indigo,
  ),
  Product(
    id: 3,
    name: 'Power Bank 20000',
    category: 'Electronics',
    price: 32,
    icon: Icons.battery_charging_full,
    color: Colors.green,
  ),
  Product(
    id: 4,
    name: 'Passport Holder',
    category: 'Accessories',
    price: 12,
    icon: Icons.book,
    color: Colors.brown,
  ),
  Product(
    id: 5,
    name: 'Polarized Sunglasses',
    category: 'Accessories',
    price: 25,
    icon: Icons.wb_sunny,
    color: Colors.amber,
  ),
  Product(
    id: 6,
    name: 'Action Camera',
    category: 'Electronics',
    price: 220,
    icon: Icons.photo_camera,
    color: Colors.teal,
  ),
];
