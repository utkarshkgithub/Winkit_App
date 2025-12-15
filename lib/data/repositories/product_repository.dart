import '../models/product_model.dart';
import '../sources/product_data_source.dart';

class ProductRepository {
  final ProductDataSource dataSource;

  ProductRepository(this.dataSource);

  Future<List<Product>> getProducts() async {
    try {
      return await dataSource.getProducts();
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      return await dataSource.getProductById(id);
    } catch (e) {
      rethrow;
    }
  }
}
