import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'saved_build.g.dart';

/// Kaydedilmiş bir kurulumdaki tek satır.
@JsonSerializable()
class SavedBuildLine {
  final Product product;
  final int quantity;

  const SavedBuildLine({required this.product, required this.quantity});

  factory SavedBuildLine.fromJson(Map<String, dynamic> json) =>
      _$SavedBuildLineFromJson(json);
  Map<String, dynamic> toJson() => _$SavedBuildLineToJson(this);
}

/// Tamamlanıp kaydedilmiş bir kurulum. `shared_preferences`'ta JSON olarak
/// saklanır (kalıcı veri örneği).
@JsonSerializable()
class SavedBuild {
  final String id;
  final double budget;
  final double spent;
  final double score;
  final DateTime savedAt;
  final List<SavedBuildLine> lines;

  const SavedBuild({
    required this.id,
    required this.budget,
    required this.spent,
    required this.score,
    required this.savedAt,
    required this.lines,
  });

  factory SavedBuild.fromJson(Map<String, dynamic> json) =>
      _$SavedBuildFromJson(json);
  Map<String, dynamic> toJson() => _$SavedBuildToJson(this);

  int get itemCount => lines.fold(0, (sum, l) => sum + l.quantity);
}
