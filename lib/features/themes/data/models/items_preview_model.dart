import '../../domain/entities/items_preview.dart';

class ItemsPreviewModel extends ItemsPreview {
  const ItemsPreviewModel({
    required super.id,
    required super.title,
    required super.description,
    required super.theoryCount,
    required super.practiceCount,
    required super.tags,
  });

  factory ItemsPreviewModel.fromIndexJson(Map<String, dynamic> json) {
    return ItemsPreviewModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',

      // просто смотрим число, а не обрабатываем целый список
      theoryCount: json['theoryCount'] as int? ?? 0,
      practiceCount: json['practiceCount'] as int? ?? 0,
      
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
    );
  }
}