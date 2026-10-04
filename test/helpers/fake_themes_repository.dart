import 'package:mobiquest/features/themes/domain/entities/items_preview.dart';
import 'package:mobiquest/features/themes/domain/interfaces/i_themes_repository.dart';

class FakeThemesRepository implements IThemesRepository {
  FakeThemesRepository([List<ItemsPreview>? items])
      : items = items ?? [];

  List<ItemsPreview> items;
  Object? error;
  int getItemsCalls = 0;

  @override
  Future<List<ItemsPreview>> getItems() async {
    getItemsCalls++;
    if (error != null) throw error!;
    return items;
  }
}