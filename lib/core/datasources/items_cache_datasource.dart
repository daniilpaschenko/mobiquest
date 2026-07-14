import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ItemsCacheDatasource {
  static const _versionsFileName = 'items_versions.json';

  Future<Directory> get _dir async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/items_cache');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> _itemFile(String id) async {
    final dir = await _dir;
    return File('${dir.path}/$id.json');
  }

  Future<File> _versionsFile() async {
    final dir = await _dir;
    return File('${dir.path}/$_versionsFileName');
  }

  Future<void> saveIndex(Map<String, dynamic> index) async {
    final dir = await _dir;
    final file = File('${dir.path}/items_index.json');
    await file.writeAsString(json.encode(index));
  }

  Future<Map<String, dynamic>?> readIndex() async {
    final dir = await _dir;
    final file = File('${dir.path}/items_index.json');
    if (!await file.exists()) return null;
    return json.decode(await file.readAsString()) as Map<String, dynamic>;
  }

  Future<void> saveItem(String id, Map<String, dynamic> data, int version) async {
    final file = await _itemFile(id);
    await file.writeAsString(json.encode(data));
    await _setVersion(id, version);
  }

  Future<Map<String, dynamic>?> readItem(String id) async {
    final file = await _itemFile(id);
    if (!await file.exists()) return null;
    return json.decode(await file.readAsString()) as Map<String, dynamic>;
  }

  Future<int?> getVersion(String id) async {
    final versions = await _readVersions();
    return versions[id] as int?;
  }

  Future<void> _setVersion(String id, int version) async {
    final versions = await _readVersions();
    versions[id] = version;
    final file = await _versionsFile();
    await file.writeAsString(json.encode(versions));
  }

  Future<Map<String, dynamic>> _readVersions() async {
    final file = await _versionsFile();
    if (!await file.exists()) return {};
    return json.decode(await file.readAsString()) as Map<String, dynamic>;
  }
}