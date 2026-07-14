import '../entities/items_preview.dart';
import '../interfaces/i_themes_repository.dart';

class GetItems {
  final IThemesRepository _repository;

  const GetItems(this._repository);

  Future<List<ItemsPreview>> call() => _repository.getItems();
}