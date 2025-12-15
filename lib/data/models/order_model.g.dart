// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderHistory _$OrderHistoryFromJson(Map<String, dynamic> json) => OrderHistory(
  id: (json['id'] as num).toInt(),
  oldStatus: json['old_status'] as String?,
  oldStatusDisplay: json['old_status_display'] as String?,
  newStatus: json['new_status'] as String,
  newStatusDisplay: json['new_status_display'] as String,
  changedByUsername: json['changed_by_username'] as String?,
  changedAt: DateTime.parse(json['changed_at'] as String),
  notes: json['notes'] as String?,
  displayMessage: json['display_message'] as String,
);

Map<String, dynamic> _$OrderHistoryToJson(OrderHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'old_status': instance.oldStatus,
      'old_status_display': instance.oldStatusDisplay,
      'new_status': instance.newStatus,
      'new_status_display': instance.newStatusDisplay,
      'changed_by_username': instance.changedByUsername,
      'changed_at': instance.changedAt.toIso8601String(),
      'notes': instance.notes,
      'display_message': instance.displayMessage,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  id: (json['id'] as num).toInt(),
  product: (json['product'] as num).toInt(),
  productName: json['product_name'] as String,
  quantity: (json['quantity'] as num).toInt(),
  price: json['price'] as String,
  subtotal: json['subtotal'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'id': instance.id,
  'product': instance.product,
  'product_name': instance.productName,
  'quantity': instance.quantity,
  'price': instance.price,
  'subtotal': instance.subtotal,
  'created_at': instance.createdAt.toIso8601String(),
};

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: (json['id'] as num).toInt(),
  user: (json['user'] as num).toInt(),
  userName: json['user_name'] as String,
  orderStatus: json['order_status'] as String,
  totalAmount: json['total_amount'] as String,
  shippingAddress: json['shipping_address'] as String,
  phoneNumber: json['phone_number'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  history: (json['history'] as List<dynamic>?)
      ?.map((e) => OrderHistory.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'user': instance.user,
  'user_name': instance.userName,
  'order_status': instance.orderStatus,
  'total_amount': instance.totalAmount,
  'shipping_address': instance.shippingAddress,
  'phone_number': instance.phoneNumber,
  'items': instance.items,
  'history': instance.history,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
