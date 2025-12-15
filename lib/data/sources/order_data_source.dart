import '../models/order_model.dart';
import '../../core/network/dio_client.dart';

class OrderDataSource {
  final DioClient client;

  OrderDataSource(this.client);

  Future<Order> createOrder(String shippingAddress, String phoneNumber) async {
    final response = await client.post(
      '/orders/',
      data: {'shipping_address': shippingAddress, 'phone_number': phoneNumber},
    );
    return Order.fromJson(response.data);
  }

  Future<Order> getOrderById(int orderId) async {
    final response = await client.get('/orders/$orderId');
    return Order.fromJson(response.data);
  }

  Future<List<Order>> getUserOrders(int userId) async {
    final response = await client.get('/orders/user/$userId');
    return (response.data as List)
        .map((order) => Order.fromJson(order as Map<String, dynamic>))
        .toList();
  }
}
