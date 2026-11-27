import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddProductEvent>(onAdd);
    on<RemoveProductEvent>(onRemove);
    on<ClearCartEvent>(onClear);
  }

  void onAdd(AddProductEvent event, Emitter<CartState> emit) {
    // Ескі тізімді өзгертпейміз, жаңа тізім жасаймыз (immutable)
    List<Product> newItems = List.from(state.items);
    newItems.add(event.product);
    emit(makeState(newItems));
  }

  void onRemove(RemoveProductEvent event, Emitter<CartState> emit) {
    List<Product> newItems = [];
    for (Product item in state.items) {
      if (item.id != event.productId) {
        newItems.add(item);
      }
    }
    emit(makeState(newItems));
  }

  void onClear(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  // Тізімнен жаңа state жасаймыз: жалпы баға мен санын есептейміз
  CartState makeState(List<Product> items) {
    double total = 0;
    for (Product item in items) {
      total += item.price;
    }
    return CartState(items: items, totalPrice: total, count: items.length);
  }
}
