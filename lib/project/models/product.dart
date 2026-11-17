class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingData = json['rating'];
    Map<String, dynamic> ratingMap = {};
    if (ratingData is Map<String, dynamic>) {
      ratingMap = ratingData;
    }

    return Product(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? 'Untitled product',
      price: _toDouble(json['price']),
      description: json['description']?.toString() ?? 'No description',
      category: json['category']?.toString() ?? 'other',
      imageUrl: json['image']?.toString() ?? '',
      rating: _toDouble(ratingMap['rate']),
      reviewCount: _toInt(ratingMap['count']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
