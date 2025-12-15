import '../models/product_model.dart';
import '../../core/network/dio_client.dart';

class ProductDataSource {
  final DioClient client;

  ProductDataSource(this.client);

  Future<List<Product>> getProducts() async {
    final response = await client.get('/products/');
    
    final List list = response.data as List;
    return list.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> getProductById(int id) async {
    final response = await client.get('/products/$id/');
    return Product.fromJson(response.data);
  }
}
