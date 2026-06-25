import 'package:sqflite/sqflite.dart';

import '../models/arrow_recommendation.dart';
import '../models/catalog_models.dart';
import 'app_database.dart';

class ArrowRepository {
  ArrowRepository([Future<Database>? db]) : _db = db ?? AppDatabase.instance;

  final Future<Database> _db;

  Future<List<BowType>> fetchBowTypes() async {
    final db = await _db;
    final rows = await db.query('bow_type', orderBy: 'id');
    return rows
        .map(
          (r) => BowType(
            id: r['id'] as int,
            code: r['code'] as String,
            description: r['description'] as String,
          ),
        )
        .toList();
  }

  Future<List<ShootingStyle>> fetchShootingStyles({int? bowTypeId}) async {
    final db = await _db;
    final rows = bowTypeId == null
        ? await db.query('shooting_style', orderBy: 'id')
        : await db.query(
            'shooting_style',
            where: 'bow_type_id = ?',
            whereArgs: [bowTypeId],
            orderBy: 'id',
          );
    return rows
        .map(
          (r) => ShootingStyle(
            id: r['id'] as int,
            code: r['code'] as String,
            description: r['description'] as String,
            bowTypeId: r['bow_type_id'] as int,
          ),
        )
        .toList();
  }

  Future<List<Manufacturer>> fetchManufacturers() async {
    final db = await _db;
    final rows = await db.query(
      'manufacturer',
      where: 'active = 1',
      orderBy: 'name',
    );
    return rows
        .map(
          (r) => Manufacturer(
            id: r['id'] as int,
            name: r['name'] as String,
            country: r['country'] as String?,
            website: r['website'] as String?,
          ),
        )
        .toList();
  }

  Future<List<ManufacturerChart>> fetchCharts({
    required int manufacturerId,
  }) async {
    final db = await _db;
    const sql = '''
      SELECT mc.id AS id,
             mc.chart_name AS chartName,
             bt.code AS bowType,
             ss.code AS shootingStyle,
             cp.code AS purpose,
             mc.version AS version,
             mc.reference_fps_min AS referenceFpsMin,
             mc.reference_fps_max AS referenceFpsMax,
             mc.reference_point_grains AS referencePointGrains
      FROM manufacturer_chart mc
      JOIN bow_type bt ON bt.id = mc.bow_type_id
      LEFT JOIN shooting_style ss ON ss.id = mc.shooting_style_id
      JOIN chart_purpose cp ON cp.id = mc.chart_purpose_id
      WHERE mc.manufacturer_id = ? AND mc.active = 1
      ORDER BY mc.chart_name
    ''';
    final rows = await db.rawQuery(sql, [manufacturerId]);
    return rows.map(_mapChart).toList();
  }

  ManufacturerChart _mapChart(Map<String, Object?> r) {
    return ManufacturerChart(
      id: r['id'] as int,
      chartName: r['chartName'] as String,
      bowType: r['bowType'] as String,
      shootingStyle: r['shootingStyle'] as String?,
      purpose: r['purpose'] as String?,
      version: r['version'] as String?,
      referenceFpsMin: r['referenceFpsMin'] as int?,
      referenceFpsMax: r['referenceFpsMax'] as int?,
      referencePointGrains: r['referencePointGrains'] as int?,
    );
  }

  Future<List<CompoundBowBrand>> fetchCompoundBowBrands() async {
    final db = await _db;
    final rows = await db.query(
      'compound_bow_brand',
      where: 'active = 1',
      orderBy: 'name',
    );
    return rows
        .map(
          (r) => CompoundBowBrand(
            id: r['id'] as int,
            name: r['name'] as String,
            country: r['country'] as String?,
            website: r['website'] as String?,
          ),
        )
        .toList();
  }

  Future<List<CompoundBowModel>> fetchCompoundBowModels({
    required int brandId,
  }) async {
    final db = await _db;
    const sql = '''
      SELECT id,
             brand_id AS brandId,
             model_name AS modelName,
             model_year AS modelYear,
             ibo_fps AS iboFps,
             draw_weight_min_lbs AS drawWeightMinLbs,
             draw_weight_max_lbs AS drawWeightMaxLbs,
             draw_length_min_in AS drawLengthMinIn,
             draw_length_max_in AS drawLengthMaxIn,
             axle_to_axle_in AS axleToAxleIn,
             brace_height_in AS braceHeightIn,
             notes
      FROM compound_bow_model
      WHERE brand_id = ? AND active = 1
      ORDER BY model_year DESC, model_name
    ''';
    final rows = await db.rawQuery(sql, [brandId]);
    return rows
        .map(
          (r) => CompoundBowModel(
            id: r['id'] as int,
            brandId: r['brandId'] as int,
            modelName: r['modelName'] as String,
            iboFps: r['iboFps'] as int,
            modelYear: r['modelYear'] as int?,
            drawWeightMinLbs: (r['drawWeightMinLbs'] as num?)?.toDouble(),
            drawWeightMaxLbs: (r['drawWeightMaxLbs'] as num?)?.toDouble(),
            drawLengthMinIn: (r['drawLengthMinIn'] as num?)?.toDouble(),
            drawLengthMaxIn: (r['drawLengthMaxIn'] as num?)?.toDouble(),
            axleToAxleIn: (r['axleToAxleIn'] as num?)?.toDouble(),
            braceHeightIn: (r['braceHeightIn'] as num?)?.toDouble(),
            notes: r['notes'] as String?,
          ),
        )
        .toList();
  }

  Future<ArrowRecommendationResult> recommend({
    required int manufacturerId,
    required int bowTypeId,
    int? shootingStyleId,
    required double drawWeightLbs,
    required double drawLengthInches,
    int? speedFps,
    double? arrowLengthInches,
    int pointWeightGrains = 100,
    String releaseType = 'MECHANICAL',
    String limbType = 'CARBON_COMPETITION',
  }) async {
    final db = await _db;
    final arrowLength = arrowLengthInches ?? (drawLengthInches + 1);

    final chartRows = await db.rawQuery(
      '''
      SELECT id,
             chart_name AS chartName,
             reference_fps_min AS referenceFpsMin,
             reference_fps_max AS referenceFpsMax,
             reference_point_grains AS referencePointGrains,
             reference_release_type AS referenceReleaseType
      FROM manufacturer_chart
      WHERE manufacturer_id = ?
        AND bow_type_id = ?
        AND (? IS NULL OR shooting_style_id = ? OR shooting_style_id IS NULL)
        AND active = 1
      ORDER BY
        CASE WHEN shooting_style_id = ? THEN 0 ELSE 1 END,
        CASE WHEN chart_name LIKE '%aluminum%' THEN 1 ELSE 0 END,
        publication_year DESC,
        id DESC
      LIMIT 1
      ''',
      [
        manufacturerId,
        bowTypeId,
        shootingStyleId,
        shootingStyleId,
        shootingStyleId,
      ],
    );

    if (chartRows.isEmpty) {
      throw ArrowRepositoryException(
        'No hay chart para este fabricante y tipo de arco',
      );
    }

    final chart = chartRows.first;
    final chartId = chart['id'] as int;
    final chartName = chart['chartName'] as String;
    final recommendedPointWeight =
        (chart['referencePointGrains'] as int?) ?? 100;

    final effectiveWeight = await _effectiveDrawWeight(
      db: db,
      chartId: chartId,
      actualWeight: drawWeightLbs,
      pointGrains: pointWeightGrains,
      fps: speedFps,
      releaseType: releaseType,
      limbType: limbType,
    );

    final spineRows = await db.rawQuery(
      '''
      SELECT recommended_spine AS recommendedSpine,
             spine_numeric AS spineNumeric,
             spine_numeric_max AS spineNumericMax,
             spine_group_code AS spineGroupCode,
             arrow_length_min AS arrowLengthMin,
             arrow_length_max AS arrowLengthMax,
             draw_weight_min AS drawWeightMin,
             draw_weight_max AS drawWeightMax,
             notes
      FROM spine_chart_entry
      WHERE chart_id = ?
        AND ? BETWEEN draw_weight_min AND draw_weight_max
        AND ? BETWEEN arrow_length_min AND arrow_length_max
      ORDER BY spine_numeric
      ''',
      [chartId, effectiveWeight, arrowLength],
    );

    final spines = spineRows.map(_mapSpine).toList();
    var arrows = <CompatibleArrow>[];

    if (spines.isNotEmpty) {
      final spineValues = spines
          .expand((s) => [s.spineNumeric, s.spineNumericMax])
          .whereType<int>()
          .toList();
      final spineMin = spineValues.isEmpty ? 0 : spineValues.reduce((a, b) => a < b ? a : b);
      final spineMax = spineValues.isEmpty ? spineMin : spineValues.reduce((a, b) => a > b ? a : b);

      final arrowRows = await db.rawQuery(
        '''
        SELECT am.id AS id,
               mf.name AS manufacturer,
               mf.id AS manufacturerId,
               am.model_name AS modelName,
               am.arrow_family AS arrowFamily,
               am.material AS material,
               am.description AS description,
               ams.spine AS spine,
               ams.spine_label AS spineLabel,
               ams.gpi AS gpi,
               ams.max_length_inches AS maxLengthInches
        FROM arrow_model am
        JOIN manufacturer mf ON mf.id = am.manufacturer_id
        JOIN arrow_model_spine ams ON ams.arrow_model_id = am.id
        WHERE mf.id = ?
          AND ams.spine BETWEEN ? AND ?
          AND ams.max_length_inches >= ?
        ORDER BY am.id, ams.spine, am.model_name
        ''',
        [manufacturerId, spineMin, spineMax, arrowLength],
      );

      arrows = _distinctArrows(arrowRows, arrowLength, pointWeightGrains);
    }

    String? message;
    if (spines.isEmpty) {
      message =
          'Sin coincidencia en el chart para peso efectivo y longitud indicados.';
    } else if (arrows.isEmpty) {
      message =
          'Spine encontrado. Añade modelos de flecha de esta marca en arrow_model.';
    }

    return ArrowRecommendationResult(
      chartId: chartId,
      chartName: chartName,
      effectiveDrawWeightLbs: effectiveWeight,
      recommendations: ArrowRecommendations(
        arrowLengthInches: arrowLength,
        pointWeightGrains: recommendedPointWeight,
        referenceFpsMin: chart['referenceFpsMin'] as int?,
        referenceFpsMax: chart['referenceFpsMax'] as int?,
        referenceReleaseType: chart['referenceReleaseType'] as String?,
      ),
      spines: spines,
      arrows: arrows,
      message: message,
    );
  }

  Future<double> _effectiveDrawWeight({
    required Database db,
    required int chartId,
    required double actualWeight,
    required int pointGrains,
    int? fps,
    required String releaseType,
    required String limbType,
  }) async {
    final rules = await db.query(
      'chart_adjustment_rule',
      where: 'chart_id = ?',
      whereArgs: [chartId],
      orderBy: 'sort_order, id',
    );

    var weight = actualWeight;
    for (final rule in rules) {
      final ruleType = rule['rule_type'] as String;
      final deltaBase = (rule['weight_delta_lbs'] as num).toDouble();
      var delta = 0.0;

      if (ruleType == 'FPS_BAND' && fps != null) {
        final min = rule['condition_min'] as num?;
        final max = rule['condition_max'] as num?;
        if ((min == null || fps >= min) && (max == null || fps <= max)) {
          delta = deltaBase;
        }
      } else if (ruleType == 'POINT_WEIGHT' && pointGrains != 100) {
        final perUnit = rule['per_unit'] as num?;
        if (perUnit != null && perUnit != 0) {
          final units = (pointGrains - 100) / perUnit;
          delta = deltaBase * units;
        }
      } else if (ruleType == 'RELEASE_TYPE') {
        if (rule['condition_code'] == releaseType) delta = deltaBase;
      } else if (ruleType == 'LIMB_TYPE') {
        if (rule['condition_code'] == limbType) delta = deltaBase;
      }

      weight += delta;
    }

    return (weight * 100).roundToDouble() / 100;
  }

  SpineMatch _mapSpine(Map<String, Object?> r) {
    return SpineMatch(
      recommendedSpine: r['recommendedSpine'] as String,
      spineNumeric: r['spineNumeric'] as int?,
      spineNumericMax: r['spineNumericMax'] as int?,
      spineGroupCode: r['spineGroupCode'] as String?,
      arrowLengthMin: (r['arrowLengthMin'] as num?)?.toDouble(),
      arrowLengthMax: (r['arrowLengthMax'] as num?)?.toDouble(),
      drawWeightMin: (r['drawWeightMin'] as num?)?.toDouble(),
      drawWeightMax: (r['drawWeightMax'] as num?)?.toDouble(),
      notes: r['notes'] as String?,
    );
  }

  List<CompatibleArrow> _distinctArrows(
    List<Map<String, Object?>> rows,
    double arrowLength,
    int pointWeight,
  ) {
    final seen = <String>{};
    final result = <CompatibleArrow>[];

    for (final r in rows) {
      final key = '${r['id']}_${r['spine']}';
      if (!seen.add(key)) continue;

      final gpi = (r['gpi'] as num?)?.toDouble();
      final shaftWeight = gpi != null
          ? ((gpi * arrowLength * 10).round() / 10)
          : null;
      final totalWeight = gpi != null
          ? (((gpi * arrowLength + pointWeight) * 10).round() / 10)
          : null;

      result.add(
        CompatibleArrow(
          id: r['id'] as int,
          manufacturer: r['manufacturer'] as String,
          manufacturerId: r['manufacturerId'] as int,
          modelName: r['modelName'] as String,
          arrowFamily: r['arrowFamily'] as String?,
          material: r['material'] as String?,
          description: r['description'] as String?,
          spine: r['spine'] as int,
          spineLabel: r['spineLabel'] as String?,
          gpi: gpi,
          maxLengthInches: (r['maxLengthInches'] as num?)?.toDouble(),
          shaftWeightGrains: shaftWeight,
          totalWeightGrains: totalWeight,
        ),
      );
    }

    return result;
  }
}

class ArrowRepositoryException implements Exception {
  ArrowRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
