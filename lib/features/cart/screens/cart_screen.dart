import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/cart_event.dart';
import '../blocs/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CartError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<CartBloc>().add(const LoadCart());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is CartLoaded) {
          if (state.cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Add items to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child: const Text('Browse Products'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Cart Items",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: state.cart.items.length,
                  itemBuilder: (context, index) {
                    final item = state.cart.items[index];
                    final product = item.productDetails;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child:
                                    product.imageUrl != null &&
                                        product.imageUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: product.imageUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                              child: Icon(
                                                Icons.shopping_basket,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            ),
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.shopping_basket,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\u{20B9}${product.discountedPrice ?? product.price}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Quantity Controls
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (item.quantity > 1) {
                                            context.read<CartBloc>().add(
                                              UpdateCartItemQuantity(
                                                productId: product.id,
                                                quantity: item.quantity - 1,
                                              ),
                                            );
                                          } else {
                                            context.read<CartBloc>().add(
                                              RemoveItemFromCart(
                                                productId: product.id,
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          item.quantity > 1
                                              ? Icons.remove_circle_outline
                                              : Icons.delete_outline,
                                        ),
                                        iconSize: 24,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          item.quantity.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (item.quantity < product.stock) {
                                            context.read<CartBloc>().add(
                                              UpdateCartItemQuantity(
                                                productId: product.id,
                                                quantity: item.quantity + 1,
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                        iconSize: 24,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\u{20B9}${item.subtotal}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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
                    );
                  },
                ),
              ),

              // Cart Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '\u{20B9}${state.cart.totalPrice}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total (${state.cart.totalItems} items)',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\u{20B9}${state.cart.totalPrice}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to checkout
                            Navigator.of(context).pushNamed('/checkout');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
