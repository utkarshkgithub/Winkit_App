import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/di/injection_container.dart';
import '../bloc/order_tracking_bloc.dart';
import '../bloc/order_tracking_event.dart';
import '../bloc/order_tracking_state.dart';
import '../widgets/order_status_timeline.dart';

class OrderTrackingScreen extends StatelessWidget {
  final int orderId;

  const OrderTrackingScreen({Key? key, required this.orderId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderTrackingBloc(orderRepository: sl())
            ..add(LoadOrderDetails(orderId)),
      child: const OrderTrackingView(),
    );
  }
}

class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        elevation: 0,
        actions: [
          BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
            builder: (context, state) {
              if (state is OrderTrackingLoaded) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<OrderTrackingBloc>().add(
                      RefreshOrderDetails(state.order.id),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
        builder: (context, state) {
          if (state is OrderTrackingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderTrackingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading order',
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
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (state is OrderTrackingLoaded) {
            final order = state.order;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<OrderTrackingBloc>().add(
                  RefreshOrderDetails(order.id),
                );
                // Wait a bit for the refresh to complete
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Header Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #${order.id}',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                _StatusBadge(status: order.orderStatus),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.calendar_today,
                              label: 'Order Date',
                              value: DateFormat(
                                'MMM dd, yyyy',
                              ).format(order.createdAt),
                            ),
                            const SizedBox(height: 8),
                            _InfoRow(
                              icon: Icons.location_on,
                              label: 'Shipping Address',
                              value: order.shippingAddress,
                            ),
                            const SizedBox(height: 8),
                            _InfoRow(
                              icon: Icons.phone,
                              label: 'Phone Number',
                              value: order.phoneNumber,
                            ),
                            const SizedBox(height: 8),
                            _InfoRow(
                              icon: Icons.attach_money,
                              label: 'Total Amount',
                              value: '\u{20B9}${order.totalAmount}',
                              valueStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Order Items
                    Text(
                      'Order Items',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...order.items.map(
                      (item) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.shopping_bag),
                          ),
                          title: Text(
                            item.productName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Quantity: ${item.quantity}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\u{20B9}${item.price}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '\u{20B9}${item.subtotal}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Order Status Timeline
                    if (order.history != null && order.history!.isNotEmpty)
                      OrderStatusTimeline(history: order.history!),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({Key? key, required this.status}) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(value, style: valueStyle ?? const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
