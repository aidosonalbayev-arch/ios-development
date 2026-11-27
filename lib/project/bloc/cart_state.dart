import 'package:equatable/equatable.dart';

import '../models/product.dart';

class CartState extends Equatable {
  final List<Product> items;
  final double totalPrice;
  final int count;

  const CartState({this.items = const [], this.totalPrice = 0, this.count = 0});

  // Тауар осы себетте бар ма?
  bool isInCart(Product product) {
    for (Product item in items) {
      if (item.id == product.id) {
        return true;
      }
    }
    return false;
  }

  @override
  List<Object> get props => [items, totalPrice, count];
}
