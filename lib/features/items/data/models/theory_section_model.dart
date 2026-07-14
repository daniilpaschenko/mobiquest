import '../../domain/entities/theory_section.dart';

class TheorySectionModel extends TheorySection {
  const TheorySectionModel({
    required super.id,
    required super.title,
    required super.body,
  });

  factory TheorySectionModel.fromJson(Map<String, dynamic> json) =>
      TheorySectionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
      );
}