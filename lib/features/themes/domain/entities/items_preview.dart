class ItemsPreview {
  final String id;
  final String title;
  final String description;
  final int theoryCount;
  final int practiceCount;
  final List<String> tags;

  const ItemsPreview({
    required this.id,
    required this.title,
    required this.description,
    required this.theoryCount,
    required this.practiceCount,
    required this.tags,
  });

  factory ItemsPreview.fromJson(Map<String, dynamic> json) {
    return ItemsPreview(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      theoryCount: (json['theory'] as List?)?.length ?? 0,
      practiceCount: (json['practice'] as List?)?.length ?? 0,
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
    );
  }
}