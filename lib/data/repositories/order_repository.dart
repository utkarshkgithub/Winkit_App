import '../models/order_model.dart';
import '../sources/order_data_source.dart';

class OrderRepository {
  final OrderDataSource dataSource;

  OrderRepository(this.dataSource);

  Future<Order> createOrder(String shippingAddress, String phoneNumber) async {
    try {
      return await dataSource.createOrder(shippingAddress, phoneNumber);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> getOrderById(int orderId) async {
    try {
      return await dataSource.getOrderById(orderId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Order>> getUserOrders(int userId) async {
    try {
      return await dataSource.getUserOrders(userId);
    } catch (e) {
      rethrow;
    }
  }
}
