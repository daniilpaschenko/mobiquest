import '../../domain/entities/items_preview.dart';

sealed class ThemesState {
  const ThemesState();
}

final class ThemesInitial extends ThemesState {
  const ThemesInitial();
}

final class ThemesLoading extends ThemesState {
  const ThemesLoading();
}

final class ThemesLoaded extends ThemesState {
  final List<ItemsPreview> allItems;
  final List<ItemsPreview> items; // отфильтрованный список для отображения
  final String query;
  final Set<String> selectedTags;

  const ThemesLoaded(
    this.allItems, {
    List<ItemsPreview>? items,
    this.query = '',
    this.selectedTags = const {},
  }) : items = items ?? allItems;

  List<String> get availableTags =>
      allItems.expand((e) => e.tags).toSet().toList()..sort();

  ThemesLoaded copyWith({
    List<ItemsPreview>? items,
    String? query,
    Set<String>? selectedTags,
  }) {
    return ThemesLoaded(
      allItems,
      items: items ?? this.items,
      query: query ?? this.query,
      selectedTags: selectedTags ?? this.selectedTags,
    );
  }
}

final class ThemesError extends ThemesState {
  final String message;
  const ThemesError(this.message);
}