import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'category_model.g.dart';

@JsonSerializable()
class Category extends Equatable {
  final int id;
  final String name;
  final String? description;
  @JsonKey(name: 'products_count')
  final int productsCount;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    required this.productsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    productsCount,
    createdAt,
    updatedAt,
  ];
}


