import 'package:equatable/equatable.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/order_model.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

class CheckoutLoaded extends CheckoutState {
  final Cart cart;

  const CheckoutLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CheckoutSubmitting extends CheckoutState {
  const CheckoutSubmitting();
}

class CheckoutSuccess extends CheckoutState {
  final Order order;

  const CheckoutSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}
