import 'package:equatable/equatable.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Category> categories;
  final List<Product> products;
  final int? selectedCategoryId;
  final String searchQuery;

  const HomeLoaded({
    required this.categories,
    required this.products,
    this.selectedCategoryId,
    this.searchQuery = '',
  });

  List<Product> get filteredProducts {
    var filtered = products;

    // Filter by category
    if (selectedCategoryId != null) {
      filtered = filtered
          .where((product) => product.category == selectedCategoryId)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((product) {
        final name = product.name.toLowerCase();
        final description = (product.description ?? '').toLowerCase();
        return name.contains(query) || description.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  List<Object?> get props => [
    categories,
    products,
    selectedCategoryId,
    searchQuery,
  ];

  HomeLoaded copyWith({
    List<Category>? categories,
    List<Product>? products,
    int? selectedCategoryId,
    bool clearCategory = false,
    String? searchQuery,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: clearCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
