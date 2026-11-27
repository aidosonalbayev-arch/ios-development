import 'package:equatable/equatable.dart';

import '../models/product.dart';

// Барлық себет оқиғаларының ата-класы
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

// Тауар қосу
class AddProductEvent extends CartEvent {
  final Product product;

  const AddProductEvent(this.product);

  @override
  List<Object> get props => [product.id];
}

// Тауарды id арқылы өшіру
class RemoveProductEvent extends CartEvent {
  final int productId;

  const RemoveProductEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

// Себетті толық тазалау
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
