import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderHistory extends Equatable {
  final int id;
  @JsonKey(name: 'old_status')
  final String? oldStatus;
  @JsonKey(name: 'old_status_display')
  final String? oldStatusDisplay;
  @JsonKey(name: 'new_status')
  final String newStatus;
  @JsonKey(name: 'new_status_display')
  final String newStatusDisplay;
  @JsonKey(name: 'changed_by_username')
  final String? changedByUsername;
  @JsonKey(name: 'changed_at')
  final DateTime changedAt;
  final String? notes;
  @JsonKey(name: 'display_message')
  final String displayMessage;

  const OrderHistory({
    required this.id,
    this.oldStatus,
    this.oldStatusDisplay,
    required this.newStatus,
    required this.newStatusDisplay,
    this.changedByUsername,
    required this.changedAt,
    this.notes,
    required this.displayMessage,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$OrderHistoryToJson(this);

  @override
  List<Object?> get props => [
    id,
    oldStatus,
    oldStatusDisplay,
    newStatus,
    newStatusDisplay,
    changedByUsername,
    changedAt,
    notes,
    displayMessage,
  ];
}

@JsonSerializable()
class OrderItem extends Equatable {
  final int id;
  final int product;
  @JsonKey(name: 'product_name')
  final String productName;
  final int quantity;
  final String price;
  final String subtotal;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const OrderItem({
    required this.id,
    required this.product,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  @override
  List<Object?> get props => [
    id,
    product,
    productName,
    quantity,
    price,
    subtotal,
    createdAt,
  ];
}

@JsonSerializable()
class Order extends Equatable {
  final int id;
  final int user;
  @JsonKey(name: 'user_name')
  final String userName;
  @JsonKey(name: 'order_status')
  final String orderStatus;
  @JsonKey(name: 'total_amount')
  final String totalAmount;
  @JsonKey(name: 'shipping_address')
  final String shippingAddress;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final List<OrderItem> items;
  final List<OrderHistory>? history;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.user,
    required this.userName,
    required this.orderStatus,
    required this.totalAmount,
    required this.shippingAddress,
    required this.phoneNumber,
    required this.items,
    this.history,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  List<Object?> get props => [
    id,
    user,
    userName,
    orderStatus,
    totalAmount,
    shippingAddress,
    history,
    phoneNumber,
    items,
    createdAt,
    updatedAt,
  ];
}
