import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/cart_model.dart';

class CartStorage {
  static const String _cartKey = 'cached_cart';
  static const String _lastSyncKey = 'cart_last_sync';

  final SharedPreferences prefs;

  CartStorage(this.prefs);

  /// Save cart to local storage
  Future<void> saveCart(Cart cart) async {
    try {
      final cartJson = jsonEncode(cart.toJson());
      await prefs.setString(_cartKey, cartJson);
      await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Log error but don't throw to prevent app crashes
      print('Error saving cart to storage: $e');
    }
  }

  /// Get cart from local storage
  Cart? getCart() {
    try {
      final cartJson = prefs.getString(_cartKey);
      if (cartJson == null) return null;

      final cartMap = jsonDecode(cartJson) as Map<String, dynamic>;
      return Cart.fromJson(cartMap);
    } catch (e) {
      // Log error and return null if cart can't be parsed
      print('Error loading cart from storage: $e');
      return null;
    }
  }

  /// Clear cart from local storage
  Future<void> clearCart() async {
    try {
      await prefs.remove(_cartKey);
      await prefs.remove(_lastSyncKey);
    } catch (e) {
      print('Error clearing cart from storage: $e');
    }
  }

  /// Get last sync timestamp
  DateTime? getLastSync() {
    final timestamp = prefs.getInt(_lastSyncKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Check if cart data exists locally
  bool hasCart() {
    return prefs.containsKey(_cartKey);
  }
}
