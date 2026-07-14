import '../entities/items_preview.dart';

abstract interface class IThemesRepository {
  Future<List<ItemsPreview>> getItems();
}