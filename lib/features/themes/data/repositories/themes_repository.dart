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

      final previews = <ItemsPreviewModel>[];
      for (final item in items) {
        final map = item as Map<String, dynamic>;
        final id = map['id'] as String;
        final version = map['version'] as int? ?? 1;
        final fullData = await _content.getItem(id, remoteVersion: version);

        previews.add(ItemsPreviewModel.fromFullJson({
          ...map,
          'theory': fullData['theory'],
          'practice': fullData['practice'],
        }));
      }
      return previews;
    } catch (e) {
      throw ContentUnavailableException(
        'Не удалось загрузить список тем: $e',
      );
    }
  }
}