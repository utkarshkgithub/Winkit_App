import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserOrders extends OrdersEvent {
  final int userId;

  const LoadUserOrders(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RefreshUserOrders extends OrdersEvent {
  final int userId;

  const RefreshUserOrders(this.userId);

  @override
  List<Object?> get props => [userId];
}
