import '../../domain/entities/items_preview.dart';
import '../../domain/interfaces/i_themes_repository.dart';
import '../models/items_preview_model.dart';
import '../../../../core/datasources/items_content_source.dart';
import '../../../../core/errors/content_unavailable_exception.dart';

class ThemesRepository implements IThemesRepository {
  final ItemsContentSource _content;

  const ThemesRepository(this._content);

  @override
  Future<List<ItemsPreview>> getItems() async {
    try {
      final index = await _content.getIndex();
      final items = index['items'] as List;

      return items
          .map((item) => ItemsPreviewModel.fromIndexJson(
                item as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      throw ContentUnavailableException(
        'Не удалось загрузить список тем: $e',
      );
    }
  }
}