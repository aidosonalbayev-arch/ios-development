import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../models/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Себет state-і өзгерген сайын экран қайта сызылады
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cart) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Cart (${cart.count})'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                } else {
                  context.go('/');
                }
              },
            ),
          ),
          body: cart.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 90,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.pop(context);
                          } else {
                            context.go('/');
                          }
                        },
                        child: const Text('Back to Shop'),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    Product product = cart.items[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 48,
                        height: 48,
                        // Feed-тегі жерлердің суреті assets ішінде тұр
                        child: product.imageUrl.startsWith('assets/')
                            ? Image.asset(product.imageUrl, fit: BoxFit.cover)
                            : Image.network(
                                product.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported);
                                },
                              ),
                      ),
                      title: Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => context.read<CartBloc>().add(
                          RemoveProductEvent(product.id),
                        ),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: cart.items.isEmpty
              ? null
              : SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Total'),
                              Text(
                                '\$${cart.totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.read<CartBloc>().add(
                            const ClearCartEvent(),
                          ),
                          icon: const Icon(Icons.delete_sweep),
                          label: const Text('Clear All'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
