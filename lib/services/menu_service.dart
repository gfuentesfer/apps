import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/menu_item.dart';

class MenuService {
  MenuService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await _client.get(Uri.parse('$_baseUrl/menu'));

    if (response.statusCode != 200) {
      throw MenuServiceException('Error al cargar el menú (${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class MenuServiceException implements Exception {
  MenuServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
