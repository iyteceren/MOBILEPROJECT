// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_build.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedBuildLine _$SavedBuildLineFromJson(Map<String, dynamic> json) =>
    SavedBuildLine(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$SavedBuildLineToJson(SavedBuildLine instance) =>
    <String, dynamic>{
      'product': instance.product,
      'quantity': instance.quantity,
    };

SavedBuild _$SavedBuildFromJson(Map<String, dynamic> json) => SavedBuild(
  id: json['id'] as String,
  budget: (json['budget'] as num).toDouble(),
  spent: (json['spent'] as num).toDouble(),
  score: (json['score'] as num).toDouble(),
  savedAt: DateTime.parse(json['savedAt'] as String),
  lines: (json['lines'] as List<dynamic>)
      .map((e) => SavedBuildLine.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SavedBuildToJson(SavedBuild instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget': instance.budget,
      'spent': instance.spent,
      'score': instance.score,
      'savedAt': instance.savedAt.toIso8601String(),
      'lines': instance.lines,
    };
