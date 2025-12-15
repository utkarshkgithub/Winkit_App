import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Product extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int? category;
  final String price;
  @JsonKey(name: 'discounted_price')
  final String? discountedPrice;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final int stock;
  final String? discount;
  @JsonKey(name: 'is_in_stock')
  final bool isInStock;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    this.category,
    required this.price,
    this.discountedPrice,
    this.imageUrl,
    required this.stock,
    this.discount,
    required this.isInStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    price,
    discountedPrice,
    imageUrl,
    stock,
    discount,
    isInStock,
    createdAt,
    updatedAt,
  ];
}


