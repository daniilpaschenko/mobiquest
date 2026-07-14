import '../../domain/entities/theory_section.dart';
import '../../domain/entities/practice_question.dart';
import '../../../themes/domain/entities/items_preview.dart';

sealed class ItemsState {
  const ItemsState();
}

final class ItemsInitial extends ItemsState {
  const ItemsInitial();
}

final class ItemsLoading extends ItemsState {
  const ItemsLoading();
}

final class TheoryLoaded extends ItemsState {
  final List<TheorySection> sections;
  const TheoryLoaded(this.sections);
}

final class PracticeLoaded extends ItemsState {
  final List<PracticeQuestion> questions;
  const PracticeLoaded(this.questions);
}

final class ItemsError extends ItemsState {
  final String message;
  const ItemsError(this.message);
}

final class PreviewsLoaded extends ItemsState {
  final List<ItemsPreview> previews;
  const PreviewsLoaded(this.previews);
}