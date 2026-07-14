import '../../domain/entities/theory_section.dart';
import '../../domain/entities/practice_question.dart';
import '../../domain/interfaces/i_items_repository.dart';
import '../models/theory_section_model.dart';
import '../models/practice_question_model.dart';
import '../../../../core/datasources/items_content_source.dart';
import '../../../../core/errors/content_unavailable_exception.dart';
import '../../../themes/data/models/items_preview_model.dart';
import '../../../themes/domain/entities/items_preview.dart';

class ItemsRepository implements IItemsRepository {
  final ItemsContentSource _content;

  const ItemsRepository(this._content);

  Future<int?> _versionOf(String id) async {
    try {
      final index = await _content.getIndex();
      return ItemsContentSource.versionOf(index, id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<TheorySection>> getTheory(String itemsId) async {
    try {
      final version = await _versionOf(itemsId);
      final data = await _content.getItem(itemsId, remoteVersion: version);
      final list = data['theory'] as List;
      return list
          .map((e) => TheorySectionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ContentUnavailableException(
        'Не удалось загрузить теорию для "$itemsId": $e',
      );
    }
  }

  @override
  Future<List<PracticeQuestion>> getPractice(String itemsId) async {
    try {
      final version = await _versionOf(itemsId);
      final data = await _content.getItem(itemsId, remoteVersion: version);
      final list = data['practice'] as List;
      return list
          .map((e) => PracticeQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ContentUnavailableException(
        'Не удалось загрузить практику для "$itemsId": $e',
      );
    }
  }

  @override
  Future<List<ItemsPreview>> getPreviews() async {
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