import '../entities/theory_section.dart';
import '../entities/practice_question.dart';
import '../../../themes/domain/entities/items_preview.dart';

abstract interface class IItemsRepository {
  Future<List<TheorySection>> getTheory(String itemsId);
  Future<List<PracticeQuestion>> getPractice(String itemsId);
  Future<List<ItemsPreview>> getPreviews();
}