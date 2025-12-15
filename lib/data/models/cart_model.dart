import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'product_model.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartItem extends Equatable {
  final int id;
  final int product;
  @JsonKey(name: 'product_details')
  final Product productDetails;
  final int quantity;
  final String subtotal;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const CartItem({
    required this.id,
    required this.product,
    required this.productDetails,
    required this.quantity,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  @override
  List<Object?> get props => [
    id,
    product,
    productDetails,
    quantity,
    subtotal,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class Cart extends Equatable {
  final int id;
  final int user;
  final List<CartItem> items;
  @JsonKey(name: 'total_items')
  final int totalItems;
  @JsonKey(name: 'total_price')
  final String totalPrice;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Cart({
    required this.id,
    required this.user,
    required this.items,
    required this.totalItems,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);

  @override
  List<Object?> get props => [
    id,
    user,
    items,
    totalItems,
    totalPrice,
    createdAt,
    updatedAt,
  ];
}
