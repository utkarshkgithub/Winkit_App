import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../widgets/order_tile.dart';

class PastOrdersScreen extends StatelessWidget {
  const PastOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Center(child: Text('Please login to view orders'));
        }

        return BlocProvider(
          create: (context) =>
              OrdersBloc(orderRepository: sl())
                ..add(LoadUserOrders(authState.user.id)),
          child: PastOrdersView(userId: authState.user.id),
        );
      },
    );
  }
}

class PastOrdersView extends StatelessWidget {
  final int userId;

  const PastOrdersView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders',),
        centerTitle: true,
        elevation: 0,
        actions: [
          BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, state) {
              // if (state is OrdersLoaded) {
              //   return IconButton(
              //     // icon: const Icon(Icons.refresh),
              //     onPressed: () {
              //       context.read<OrdersBloc>().add(RefreshUserOrders(userId));
              //     },
              //   );
              // }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrdersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading orders',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<OrdersBloc>().add(LoadUserOrders(userId));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is OrdersEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start shopping to create your first order!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state is OrdersLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<OrdersBloc>().add(RefreshUserOrders(userId));
                // Wait a bit for the refresh to complete
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return OrderTile(
                    order: order,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed('/order-tracking', arguments: order.id);
                    },
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
