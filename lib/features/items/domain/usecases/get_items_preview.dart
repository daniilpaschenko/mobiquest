import '../../../themes/domain/entities/items_preview.dart';
import '../interfaces/i_items_repository.dart';

class GetItemsPreviews {
  final IItemsRepository _repository;

  const GetItemsPreviews(this._repository);

  Future<List<ItemsPreview>> call() => _repository.getPreviews();
}