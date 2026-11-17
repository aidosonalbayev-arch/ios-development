import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import 'detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Product> items = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts({bool showSpinner = true}) async {
    if (showSpinner) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      List<Product> result = await ProductService.fetchProducts();
      if (!mounted) return;
      setState(() {
        items = result;
        isLoading = false;
        errorMessage = null;
      });
    } on ApiException catch (e) {
      showError(e.message);
    } on TimeoutException {
      showError('Connection timed out. Please try again.');
    } catch (e) {
      showError('No internet connection. Check your network and retry.');
    }
  }

  void showError(String message) {
    if (!mounted) return;
    if (items.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    setState(() {
      isLoading = false;
      errorMessage = message;
    });
  }

  Widget buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 90, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => loadProducts(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Connection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(Product product) {
    final cart = context.watch<CartProvider>();
    bool inCart = cart.isInCart(product);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      leading: Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Hero(
          tag: 'product_image_${product.id}',
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported);
            },
          ),
        ),
      ),
      title: Text(
        product.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 2),
                Text(
                  '${product.rating.toStringAsFixed(1)} '
                  '(${product.reviewCount})',
                ),
              ],
            ),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
          ],
        ),
      ),
      trailing: IconButton(
        onPressed: () => context.read<CartProvider>().toggle(product),
        icon: Icon(
          inCart ? Icons.shopping_cart : Icons.add_shopping_cart,
          color: inCart ? Colors.teal : Colors.grey,
        ),
      ),
    );
  }

  Widget buildFeed() {
    return RefreshIndicator(
      onRefresh: () => loadProducts(showSpinner: false),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) {
          return const Divider(height: 1, thickness: 0.5);
        },
        itemBuilder: (context, index) => buildItem(items[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return buildError();
    }
    return buildFeed();
  }
}
