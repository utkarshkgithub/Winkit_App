import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  final bool force;

  const LoadCart({this.force = false});

  @override
  List<Object?> get props => [force];
}

class AddItemToCart extends CartEvent {
  final int productId;
  final int quantity;

  const AddItemToCart({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateCartItemQuantity extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateCartItemQuantity({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveItemFromCart extends CartEvent {
  final int productId;

  const RemoveItemFromCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}
