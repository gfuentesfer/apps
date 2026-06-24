import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/arrow_recommendation.dart';
import '../models/catalog_models.dart';

class ArrowService {
  ArrowService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<List<BowType>> fetchBowTypes() async {
    final response = await _client.get(Uri.parse('$_baseUrl/api/catalog/bow-types'));
    _ensureOk(response, 'tipos de arco');
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => BowType.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ShootingStyle>> fetchShootingStyles({int? bowTypeId}) async {
    final uri = bowTypeId == null
        ? Uri.parse('$_baseUrl/api/catalog/shooting-styles')
        : Uri.parse('$_baseUrl/api/catalog/shooting-styles?bowTypeId=$bowTypeId');
    final response = await _client.get(uri);
    _ensureOk(response, 'estilos de tiro');
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => ShootingStyle.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Manufacturer>> fetchManufacturers() async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/api/catalog/manufacturers'));
    _ensureOk(response, 'fabricantes');
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => Manufacturer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ManufacturerChart>> fetchCharts({required int manufacturerId}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/catalog/charts?manufacturerId=$manufacturerId'),
    );
    _ensureOk(response, 'charts');
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => ManufacturerChart.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CompoundBowBrand>> fetchCompoundBowBrands() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/catalog/compound-bow-brands'),
    );
    _ensureOk(response, 'marcas de arco compuesto');
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => CompoundBowBrand.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CompoundBowModel>> fetchCompoundBowModels({
    required int brandId,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/catalog/compound-bow-models?brandId=$brandId'),
    );
    _ensureOk(response, 'modelos de arco compuesto');
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => CompoundBowModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ArrowRecommendationResult> recommend({
    required int manufacturerId,
    required int bowTypeId,
    int? shootingStyleId,
    required double drawWeightLbs,
    required double drawLengthInches,
    int? speedFps,
  }) async {
    final body = {
      'manufacturerId': manufacturerId,
      'bowTypeId': bowTypeId,
      if (shootingStyleId != null) 'shootingStyleId': shootingStyleId,
      'drawWeightLbs': drawWeightLbs,
      'drawLengthInches': drawLengthInches,
      if (speedFps != null) 'speedFps': speedFps,
    };

    final response = await _client.post(
      Uri.parse('$_baseUrl/api/arrows/recommend'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      throw ArrowServiceException(
        decoded['error'] as String? ?? 'Error al calcular (${response.statusCode})',
      );
    }

    return ArrowRecommendationResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  void _ensureOk(http.Response response, String resource) {
    if (response.statusCode != 200) {
      throw ArrowServiceException(
        'Error al cargar $resource (${response.statusCode})',
      );
    }
  }
}

class ArrowServiceException implements Exception {
  ArrowServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
