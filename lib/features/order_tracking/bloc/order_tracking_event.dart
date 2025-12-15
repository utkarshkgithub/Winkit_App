import 'package:equatable/equatable.dart';

abstract class OrderTrackingEvent extends Equatable {
  const OrderTrackingEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderDetails extends OrderTrackingEvent {
  final int orderId;

  const LoadOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class RefreshOrderDetails extends OrderTrackingEvent {
  final int orderId;

  const RefreshOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
