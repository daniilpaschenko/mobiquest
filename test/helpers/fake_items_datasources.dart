import 'package:mobiquest/core/datasources/items_cache_datasource.dart';
import 'package:mobiquest/core/datasources/items_remote_datasource.dart';

/// Тело, которое сервер отдаст по [id] (или по индексу).
typedef ItemBody = Map<String, dynamic>;

class FakeItemsRemoteDatasource implements ItemsRemoteDatasource {
  FakeItemsRemoteDatasource({
    Map<String, ItemBody>? items,
    this.index,
  }) : items = items ?? {};

  /// Что сервер вернёт по [fetchItem]; отсутствие id = 404
  final Map<String, ItemBody> items;

  /// Что сервер вернёт по [fetchIndex]
  ItemBody? index;

  /// Если задано, любой запрос к сети бросает это
  Object? error;

  /// id, для которых реально дёрнули сеть, по порядку вызовов
  final List<String> fetchedItems = [];
  int fetchIndexCalls = 0;

  @override
  Future<ItemBody> fetchItem(String id) async {
    fetchedItems.add(id);
    if (error != null) throw error!;
    final body = items[id];
    if (body == null) throw Exception('404 $id');
    return body;
  }

  @override
  Future<ItemBody> fetchIndex() async {
    fetchIndexCalls++;
    if (error != null) throw error!;
    if (index == null) throw Exception('no index');
    return index!;
  }
}

class FakeItemsCacheDatasource implements ItemsCacheDatasource {
  FakeItemsCacheDatasource({
    Map<String, ItemBody>? items,
    Map<String, int>? versions,
    this.index,
  })  : items = items ?? {},
        versions = versions ?? {};

  final Map<String, ItemBody> items;
  final Map<String, int> versions;
  ItemBody? index;

  Object? error;

  /// Вызовы [saveItem] как (id, тело, версия) — по порядку
  final List<(String, ItemBody, int)> savedItems = [];
  int saveIndexCalls = 0;

  /// Счётчик [readItem], чтобы отличить «кэш прочитали» от «кэш пуст»
  int readItemCalls = 0;

  @override
  Future<int?> getVersion(String id) async {
    if (error != null) throw error!;
    return versions[id];
  }

  @override
  Future<ItemBody?> readItem(String id) async {
    readItemCalls++;
    if (error != null) throw error!;
    return items[id];
  }

  @override
  Future<void> saveItem(String id, ItemBody data, int version) async {
    if (error != null) throw error!;
    savedItems.add((id, data, version));
    items[id] = data;
    versions[id] = version;
  }

  @override
  Future<ItemBody?> readIndex() async {
    if (error != null) throw error!;
    return index;
  }

  @override
  Future<void> saveIndex(ItemBody data) async {
    if (error != null) throw error!;
    saveIndexCalls++;
    index = data;
  }
}