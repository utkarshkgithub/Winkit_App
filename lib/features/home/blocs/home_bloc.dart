import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/category_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;

  HomeBloc({required this.productRepository, required this.categoryRepository})
    : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SelectCategory>(_onSelectCategory);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final categories = await categoryRepository.getCategories();
      final products = await productRepository.getProducts();

      emit(
        HomeLoaded(
          categories: categories,
          products: products,
          searchQuery: '',
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onSelectCategory(
    SelectCategory event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        currentState.copyWith(
          selectedCategoryId: event.categoryId,
          clearCategory: event.categoryId == null,
        ),
      );
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final categories = await categoryRepository.getCategories();
      final products = await productRepository.getProducts();

      emit(
        HomeLoaded(
          categories: categories,
          products: products,
          searchQuery: '',
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }
}
