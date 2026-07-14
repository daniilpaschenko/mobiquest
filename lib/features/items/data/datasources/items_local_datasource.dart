import 'dart:convert';
import 'package:flutter/services.dart';

class ItemsLocalDatasource {
  Future<Map<String, dynamic>> loadBundled(String itemsId) async {
    final raw = await rootBundle.loadString('assets/items/$itemsId.json');
    return json.decode(raw) as Map<String, dynamic>;
  }
}