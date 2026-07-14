sealed class ThemesEvent {
  const ThemesEvent();
}

final class LoadItems extends ThemesEvent {
  const LoadItems();
}

final class FilterItems extends ThemesEvent {
  final String query;
  final Set<String> selectedTags;
  const FilterItems({this.query = '', this.selectedTags = const {}});
}