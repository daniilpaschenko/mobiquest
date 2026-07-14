import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_items.dart';
import 'themes_event.dart';
import 'themes_state.dart';

class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  final GetItems _getItems;

  ThemesBloc({required this._getItems}) : super(const ThemesInitial()) {
    on<LoadItems>(_onLoadItems);
    on<FilterItems>(_onFilterItems);
  }

  Future<void> _onLoadItems(
    LoadItems event,
    Emitter<ThemesState> emit,
  ) async {
    emit(const ThemesLoading());
    try {
      final items = await _getItems();
      emit(ThemesLoaded(items));
    } catch (e) {
      emit(ThemesError(e.toString()));
    }
  }

  void _onFilterItems(
    FilterItems event,
    Emitter<ThemesState> emit,
  ) {
    final state = this.state;
    if (state is! ThemesLoaded) return;

    final filtered = state.allItems.where((item) {
      final matchesQuery = event.query.isEmpty ||
          item.title.toLowerCase().contains(event.query.toLowerCase()) ||
          item.description.toLowerCase().contains(event.query.toLowerCase());

      final matchesTags = event.selectedTags.isEmpty ||
          event.selectedTags.every((tag) => item.tags.contains(tag)); // все теги (every)

      return matchesQuery && matchesTags;
    }).toList();

    emit(state.copyWith(
      items: filtered,
      query: event.query,
      selectedTags: event.selectedTags,
    ));
  }
}