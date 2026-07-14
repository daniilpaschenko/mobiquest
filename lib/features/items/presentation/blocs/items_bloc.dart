import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_items_theory.dart';
import '../../domain/usecases/get_items_practice.dart';
import '../../domain/usecases/get_items_preview.dart';
import 'items_event.dart';
import 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final GetItemsTheory _getItemsTheory;
  final GetItemsPractice _getItemsPractice;
  final GetItemsPreviews _getItemsPreviews;

  ItemsBloc({
    required this._getItemsTheory,
    required this._getItemsPractice,
    required this._getItemsPreviews,
  }) : super(const ItemsInitial()) {
    on<LoadTheory>(_onLoadTheory);
    on<LoadPractice>(_onLoadPractice);
    on<LoadPreviews>(_onLoadPreviews);
  }

  Future<void> _onLoadTheory(
    LoadTheory event,
    Emitter<ItemsState> emit,
  ) async {
    emit(const ItemsLoading());
    try {
      final sections = await _getItemsTheory(event.itemsId);
      emit(TheoryLoaded(sections));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  Future<void> _onLoadPractice(
    LoadPractice event,
    Emitter<ItemsState> emit,
  ) async {
    emit(const ItemsLoading());
    try {
      final questions = await _getItemsPractice(event.itemsId);
      emit(PracticeLoaded(questions));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  Future<void> _onLoadPreviews(
    LoadPreviews event,
    Emitter<ItemsState> emit,
  ) async {
    emit(const ItemsLoading());
    try {
      final previews = await _getItemsPreviews();
      emit(PreviewsLoaded(previews));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }
}