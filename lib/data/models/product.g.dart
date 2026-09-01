// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  tagline: json['tagline'] as String,
  description: json['description'] as String,
  priceLabel: json['price'] as String,
  currency: json['currency'] as String,
  imageUrl: json['image'] as String,
  specs: Map<String, String>.from(json['specs'] as Map),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'tagline': instance.tagline,
  'description': instance.description,
  'price': instance.priceLabel,
  'currency': instance.currency,
  'image': instance.imageUrl,
  'specs': instance.specs,
};
