import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/storage/token_storage.dart';
import '../../common/storage/cart_storage.dart';
import '../network/dio_client.dart';
import '../../data/sources/auth_data_source.dart';
import '../../data/sources/product_data_source.dart';
import '../../data/sources/category_data_source.dart';
import '../../data/sources/cart_data_source.dart';
import '../../data/sources/order_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/order_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core
  sl.registerLazySingleton(() => TokenStorage(sl()));
  sl.registerLazySingleton(() => CartStorage(sl()));
  sl.registerLazySingleton(() => DioClient(tokenStorage: sl()));

  // Data sources
  sl.registerLazySingleton(() => AuthDataSource(sl<DioClient>()));
  sl.registerLazySingleton(() => ProductDataSource(sl<DioClient>()));
  sl.registerLazySingleton(() => CategoryDataSource(sl<DioClient>()));
  sl.registerLazySingleton(() => CartDataSource(sl<DioClient>()));
  sl.registerLazySingleton(() => OrderDataSource(sl<DioClient>()));

  // Repositories
  sl.registerLazySingleton(
    () => AuthRepository(
      dataSource: sl<AuthDataSource>(),
      tokenStorage: sl<TokenStorage>(),
    ),
  );
  sl.registerLazySingleton(() => ProductRepository(sl<ProductDataSource>()));
  sl.registerLazySingleton(() => CategoryRepository(sl<CategoryDataSource>()));
  sl.registerLazySingleton(
    () => CartRepository(sl<CartDataSource>(), sl<CartStorage>()),
  );
  sl.registerLazySingleton(() => OrderRepository(sl<OrderDataSource>()));
}
