import 'package:equatable/equatable.dart';
import '../../../data/models/order_model.dart';

abstract class OrderTrackingState extends Equatable {
  const OrderTrackingState();

  @override
  List<Object?> get props => [];
}

class OrderTrackingInitial extends OrderTrackingState {
  const OrderTrackingInitial();
}

class OrderTrackingLoading extends OrderTrackingState {
  const OrderTrackingLoading();
}

class OrderTrackingLoaded extends OrderTrackingState {
  final Order order;

  const OrderTrackingLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderTrackingError extends OrderTrackingState {
  final String message;

  const OrderTrackingError(this.message);

  @override
  List<Object?> get props => [message];
}
