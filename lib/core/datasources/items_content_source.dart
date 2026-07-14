import 'items_remote_datasource.dart';
import 'items_cache_datasource.dart';

class ItemsContentSource {
  final ItemsRemoteDatasource _remote;
  final ItemsCacheDatasource _cache;

  const ItemsContentSource(this._remote, this._cache);

  Future<Map<String, dynamic>> getIndex() async {
    try {
      final remote = await _remote.fetchIndex();
      await _cache.saveIndex(remote);
      return remote;
    } catch (_) {
      final cached = await _cache.readIndex();
      if (cached != null) return cached;
      throw Exception('No index available: no network and no cache');
    }
  }

  Future<Map<String, dynamic>> getItem(String id, {int? remoteVersion}) async {
    final cachedVersion = await _cache.getVersion(id);

    final cacheIsFresh = remoteVersion != null &&
        cachedVersion != null &&
        cachedVersion >= remoteVersion;

    if (cacheIsFresh) {
      final cached = await _cache.readItem(id);
      if (cached != null) return cached;
    }

    if (remoteVersion != null) {
      try {
        final fresh = await _remote.fetchItem(id);
        await _cache.saveItem(id, fresh, remoteVersion);
        return fresh;
      } catch (_) {
        // сеть подвела — падаем ниже на кэш/bundled
      }
    }

    final cached = await _cache.readItem(id);
    if (cached != null) return cached;

    throw Exception('No data available for item "$id": no network and no cache');
  }

  static int versionOf(Map<String, dynamic> index, String id) {
    final items = index['items'] as List;
    final entry = items.firstWhere((e) => e['id'] == id) as Map<String, dynamic>;
    return entry['version'] as int? ?? 1;
  }
}