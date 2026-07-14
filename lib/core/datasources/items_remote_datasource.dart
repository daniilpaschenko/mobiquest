import 'package:dio/dio.dart';
import '../config/remote_content_config.dart';

class ItemsRemoteDatasource {
  final Dio _dio;

  const ItemsRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> fetchIndex() async {
    final res = await _dio.get(
      '${RemoteContentConfig.baseUrl}/items_index.json',
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchItem(String id) async {
    final res = await _dio.get(
      '${RemoteContentConfig.baseUrl}/$id.json',
    );
    return res.data as Map<String, dynamic>;
  }
}