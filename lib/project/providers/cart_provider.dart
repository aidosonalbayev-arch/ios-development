import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  double get total {
    double sum = 0;
    for (Product product in _items) {
      sum += product.price;
    }
    return sum;
  }

  bool isInCart(Product product) {
    return _items.any((item) => item.id == product.id);
  }

  void toggle(Product product) {
    if (isInCart(product)) {
      _items.removeWhere((item) => item.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
