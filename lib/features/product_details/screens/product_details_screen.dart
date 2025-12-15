import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/product_model.dart';
import '../../cart/blocs/cart_bloc.dart';
import '../../cart/blocs/cart_event.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    if (_quantity < widget.product.stock) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _addToCart() {
    context.read<CartBloc>().add(
      AddItemToCart(productId: widget.product.id, quantity: _quantity),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        widget.product.discount != null &&
        widget.product.discountedPrice != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child:
                      widget.product.imageUrl != null &&
                          widget.product.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.product.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.shopping_basket,
                              size: 120,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.shopping_basket,
                            size: 120,
                            color: Colors.grey,
                          ),
                        ),
                ),
                // Discount Badge
                if (hasDiscount)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.product.discount}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Stock Badge
                if (!widget.product.isInStock)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Stock Status
                  Row(
                    children: [
                      Icon(
                        widget.product.isInStock
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: widget.product.isInStock
                            ? Colors.green
                            : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.product.isInStock
                            ? 'In Stock (${widget.product.stock} available)'
                            : 'Out of Stock',
                        style: TextStyle(
                          color: widget.product.isInStock
                              ? Colors.green
                              : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price Section
                  Row(
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          '\u{20B9}${widget.product.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Text(
                        '\u{20B9}${widget.product.discountedPrice ?? widget.product.price}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  if (widget.product.description != null &&
                      widget.product.description!.isNotEmpty) ...[
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Quantity Selector
                  const Text(
                    'Quantity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _decrementQuantity,
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _quantity.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _incrementQuantity,
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Spacer(),
                      Text(
                        'Total: \u{20B9}${((double.tryParse(widget.product.discountedPrice ?? widget.product.price) ?? 0) * _quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: widget.product.isInStock ? _addToCart : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Add to Cart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
