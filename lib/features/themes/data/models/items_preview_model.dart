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

  factory ItemsPreviewModel.fromFullJson(Map<String, dynamic> json) {
    return ItemsPreviewModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      theoryCount: (json['theory'] as List?)?.length ?? 0,
      practiceCount: (json['practice'] as List?)?.length ?? 0,
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
    );
  }
}