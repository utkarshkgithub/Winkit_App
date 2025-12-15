// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  id: (json['id'] as num).toInt(),
  product: (json['product'] as num).toInt(),
  productDetails: Product.fromJson(
    json['product_details'] as Map<String, dynamic>,
  ),
  quantity: (json['quantity'] as num).toInt(),
  subtotal: json['subtotal'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'product': instance.product,
  'product_details': instance.productDetails,
  'quantity': instance.quantity,
  'subtotal': instance.subtotal,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
  id: (json['id'] as num).toInt(),
  user: (json['user'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalItems: (json['total_items'] as num).toInt(),
  totalPrice: json['total_price'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
  'id': instance.id,
  'user': instance.user,
  'items': instance.items,
  'total_items': instance.totalItems,
  'total_price': instance.totalPrice,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
