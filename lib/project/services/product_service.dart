import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class ProductService {
  static const String url = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is! List) {
        throw ApiException(200, 'Unexpected response format.');
      }
      return data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 404) {
      throw ApiException(404, 'Products not found (404).');
    }

    if (response.statusCode >= 500) {
      throw ApiException(
        response.statusCode,
        'Server error (${response.statusCode}). Please try again later.',
      );
    }

    throw ApiException(
      response.statusCode,
      'Unexpected error (${response.statusCode}).',
    );
  }
}
