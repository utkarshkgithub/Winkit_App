import '../models/category_model.dart';
import '../../core/network/dio_client.dart';

class CategoryDataSource {
  final DioClient client;

  CategoryDataSource(this.client);

  Future<List<Category>> getCategories() async {
    final response = await client.get('/categories/');
    
    final List list = response.data as List;
    return list.map((e) => Category.fromJson(e)).toList();
  }

  Future<Category> getCategoryById(int id) async {
    final response = await client.get('/categories/$id/');
    return Category.fromJson(response.data);
  }
}
