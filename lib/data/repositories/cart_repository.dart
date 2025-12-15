import '../models/cart_model.dart';
import '../sources/cart_data_source.dart';
import '../../common/storage/cart_storage.dart';

class CartRepository {
  final CartDataSource dataSource;
  final CartStorage storage;

  CartRepository(this.dataSource, this.storage);

  Future<Cart> getCart() async {
    try {
      // Try to get from server first
      final cart = await dataSource.getCart();
      // Save to local storage
      await storage.saveCart(cart);
      return cart;
    } catch (e) {
      // If network fails, try to get from local storage
      final cachedCart = storage.getCart();
      if (cachedCart != null) {
        return cachedCart;
      }
      rethrow;
    }
  }

  Future<Cart> addToCart(int productId, int quantity) async {
    try {
      final cart = await dataSource.addToCart(productId, quantity);
      // Save to local storage
      await storage.saveCart(cart);
      return cart;
    } catch (e) {
      rethrow;
    }
  }

  Future<Cart> updateCartItem(int productId, int quantity) async {
    try {
      final cart = await dataSource.updateCartItem(productId, quantity);
      // Save to local storage
      await storage.saveCart(cart);
      return cart;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await dataSource.clearCart();
      // Clear from local storage
      await storage.clearCart();
    } catch (e) {
      rethrow;
    }
  }

  /// Get cached cart from local storage (offline mode)
  Cart? getCachedCart() {
    return storage.getCart();
  }

  /// Check if cart exists in local storage
  bool hasLocalCart() {
    return storage.hasCart();
  }
}
