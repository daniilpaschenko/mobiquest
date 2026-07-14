import '../entities/practice_question.dart';
import '../interfaces/i_items_repository.dart';

class GetItemsPractice {
  final IItemsRepository _repository;

  const GetItemsPractice(this._repository);

  Future<List<PracticeQuestion>> call(String itemsId) =>
      _repository.getPractice(itemsId);
}