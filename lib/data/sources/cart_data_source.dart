import '../models/cart_model.dart';
import '../../core/network/dio_client.dart';

class CartDataSource {
  final DioClient client;

  CartDataSource(this.client);

  Future<Cart> getCart() async {
    final response = await client.get('/cart/');
    return Cart.fromJson(response.data);
  }

  Future<Cart> addToCart(int productId, int quantity) async {
    final response = await client.post(
      '/cart/add',
      data: {'product_id': productId, 'quantity': quantity},
    );
    return Cart.fromJson(response.data);
  }

  Future<Cart> updateCartItem(int productId, int quantity) async {
    final response = await client.post(
      '/cart/update',
      data: {'product_id': productId, 'quantity': quantity},
    );
    return Cart.fromJson(response.data);
  }

  Future<void> clearCart() async {
    await client.delete('/cart/clear');
  }
}
