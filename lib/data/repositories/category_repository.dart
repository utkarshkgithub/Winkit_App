import '../models/category_model.dart';
import '../sources/category_data_source.dart';

class CategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepository(this.dataSource);

  Future<List<Category>> getCategories() async {
    try {
      return await dataSource.getCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<Category> getCategoryById(int id) async {
    try {
      return await dataSource.getCategoryById(id);
    } catch (e) {
      rethrow;
    }
  }
}
