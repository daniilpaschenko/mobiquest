import '../entities/theory_section.dart';
import '../interfaces/i_items_repository.dart';

class GetItemsTheory {
  final IItemsRepository _repository;

  const GetItemsTheory(this._repository);

  Future<List<TheorySection>> call(String itemsId) =>
      _repository.getTheory(itemsId);
}