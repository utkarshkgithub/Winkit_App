import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';

class OrderStatusTimeline extends StatelessWidget {
  final List<OrderHistory> history;

  const OrderStatusTimeline({Key? key, required this.history})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort history by date (newest first)
    final sortedHistory = List<OrderHistory>.from(history)
      ..sort((a, b) => b.changedAt.compareTo(a.changedAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Status History',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedHistory.length,
          itemBuilder: (context, index) {
            final historyItem = sortedHistory[index];
            final isLast = index == sortedHistory.length - 1;

            return _TimelineItem(historyItem: historyItem, isLast: isLast);
          },
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final OrderHistory historyItem;
  final bool isLast;

  const _TimelineItem({
    Key? key,
    required this.historyItem,
    required this.isLast,
  }) : super(key: key);

  Color _getStatusColor(String status) {
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'processing':
        return Icons.inventory_2;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(historyItem.newStatus);
    final statusIcon = _getStatusIcon(historyItem.newStatus);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: statusColor, width: 2),
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade300),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Status details
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    historyItem.newStatusDisplay,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      'MMM dd, yyyy \'at\' hh:mm a',
                    ).format(historyItem.changedAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  if (historyItem.notes != null &&
                      historyItem.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      historyItem.notes!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                  if (historyItem.changedByUsername != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Updated by: ${historyItem.changedByUsername}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
