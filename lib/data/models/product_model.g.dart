// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  category: (json['category'] as num?)?.toInt(),
  price: json['price'] as String,
  discountedPrice: json['discounted_price'] as String?,
  imageUrl: json['image_url'] as String?,
  stock: (json['stock'] as num).toInt(),
  discount: json['discount'] as String?,
  isInStock: json['is_in_stock'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'category': instance.category,
  'price': instance.price,
  'discounted_price': instance.discountedPrice,
  'image_url': instance.imageUrl,
  'stock': instance.stock,
  'discount': instance.discount,
  'is_in_stock': instance.isInStock,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
