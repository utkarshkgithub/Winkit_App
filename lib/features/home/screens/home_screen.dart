import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/error_display_widget.dart';
import '../../../common/widgets/empty_state_widget.dart';
import '../blocs/home_bloc.dart';
import '../blocs/home_event.dart';
import '../blocs/home_state.dart';
import '../widgets/category_tile.dart';
import '../widgets/product_card.dart';
import '../../../data/models/category_model.dart';
import '../../cart/blocs/cart_bloc.dart';
import '../../cart/blocs/cart_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use existing HomeBloc from ancestor instead of creating new one
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const LoadingWidget();
        }

        if (state is HomeError) {
          return ErrorDisplayWidget(
            message: state.message,
            onRetry: () {
              context.read<HomeBloc>().add(const LoadHomeData());
            },
          );
        }

        if (state is HomeLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const RefreshHomeData());
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                          onChanged: (value) {
                            context.read<HomeBloc>().add(SearchProducts(value));
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Categories Section
                      if (state.categories.isNotEmpty) ...[
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.categories.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return CategoryTile(
                                  category: Category(
                                    id: 0,
                                    name: 'All',
                                    description: null,
                                    productsCount: 0,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                  ),
                                  isSelected: state.selectedCategoryId == null,
                                  onTap: () {
                                    context.read<HomeBloc>().add(
                                      const SelectCategory(null),
                                    );
                                  },
                                );
                              }
                              final category = state.categories[index - 1];
                              return CategoryTile(
                                category: category,
                                isSelected:
                                    state.selectedCategoryId == category.id,
                                onTap: () {
                                  context.read<HomeBloc>().add(
                                    SelectCategory(category.id),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
                // Products Grid
                state.filteredProducts.isEmpty
                    ? const SliverFillRemaining(
                        child: EmptyStateWidget(
                          message: 'No products available',
                          icon: Icons.shopping_bag_outlined,
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = state.filteredProducts[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/product',
                                  arguments: product,
                                );
                              },
                              onAddToCart: () {
                                context.read<CartBloc>().add(
                                  AddItemToCart(
                                    productId: product.id,
                                    quantity: 1,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.name} added to cart',
                                    ),
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'View Cart',
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/cart');
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }, childCount: state.filteredProducts.length),
                        ),
                      ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
