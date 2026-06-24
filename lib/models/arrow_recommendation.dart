import '../utils/json_parse.dart';

class ArrowRecommendations {
  const ArrowRecommendations({
    required this.arrowLengthInches,
    required this.pointWeightGrains,
    this.referenceFpsMin,
    this.referenceFpsMax,
    this.referenceReleaseType,
  });

  final double arrowLengthInches;
  final int pointWeightGrains;
  final int? referenceFpsMin;
  final int? referenceFpsMax;
  final String? referenceReleaseType;

  factory ArrowRecommendations.fromJson(Map<String, dynamic> json) {
    return ArrowRecommendations(
      arrowLengthInches: parseJsonDouble(json['arrowLengthInches']),
      pointWeightGrains: parseJsonInt(json['pointWeightGrains']),
      referenceFpsMin: parseJsonIntOrNull(json['referenceFpsMin']),
      referenceFpsMax: parseJsonIntOrNull(json['referenceFpsMax']),
      referenceReleaseType: json['referenceReleaseType'] as String?,
    );
  }
}

class SpineMatch {
  const SpineMatch({
    required this.recommendedSpine,
    this.spineNumeric,
    this.spineNumericMax,
    this.spineGroupCode,
    this.arrowLengthMin,
    this.arrowLengthMax,
    this.drawWeightMin,
    this.drawWeightMax,
    this.notes,
  });

  final String recommendedSpine;
  final int? spineNumeric;
  final int? spineNumericMax;
  final String? spineGroupCode;
  final double? arrowLengthMin;
  final double? arrowLengthMax;
  final double? drawWeightMin;
  final double? drawWeightMax;
  final String? notes;

  factory SpineMatch.fromJson(Map<String, dynamic> json) {
    return SpineMatch(
      recommendedSpine: json['recommendedSpine'] as String,
      spineNumeric: parseJsonIntOrNull(json['spineNumeric']),
      spineNumericMax: parseJsonIntOrNull(json['spineNumericMax']),
      spineGroupCode: json['spineGroupCode'] as String?,
      arrowLengthMin: parseJsonDoubleOrNull(json['arrowLengthMin']),
      arrowLengthMax: parseJsonDoubleOrNull(json['arrowLengthMax']),
      drawWeightMin: parseJsonDoubleOrNull(json['drawWeightMin']),
      drawWeightMax: parseJsonDoubleOrNull(json['drawWeightMax']),
      notes: json['notes'] as String?,
    );
  }
}

class CompatibleArrow {
  const CompatibleArrow({
    required this.id,
    required this.manufacturer,
    required this.manufacturerId,
    required this.modelName,
    this.arrowFamily,
    this.material,
    this.description,
    required this.spine,
    this.spineLabel,
    this.gpi,
    this.maxLengthInches,
    this.shaftWeightGrains,
    this.totalWeightGrains,
  });

  final int id;
  final String manufacturer;
  final int manufacturerId;
  final String modelName;
  final String? arrowFamily;
  final String? material;
  final String? description;
  final int spine;
  final String? spineLabel;
  final double? gpi;
  final double? maxLengthInches;
  final double? shaftWeightGrains;
  final double? totalWeightGrains;

  factory CompatibleArrow.fromJson(Map<String, dynamic> json) {
    return CompatibleArrow(
      id: parseJsonInt(json['id']),
      manufacturer: json['manufacturer'] as String,
      manufacturerId: parseJsonInt(json['manufacturerId']),
      modelName: json['modelName'] as String,
      arrowFamily: json['arrowFamily'] as String?,
      material: json['material'] as String?,
      description: json['description'] as String?,
      spine: parseJsonInt(json['spine']),
      spineLabel: json['spineLabel'] as String?,
      gpi: parseJsonDoubleOrNull(json['gpi']),
      maxLengthInches: parseJsonDoubleOrNull(json['maxLengthInches']),
      shaftWeightGrains: parseJsonDoubleOrNull(json['shaftWeightGrains']),
      totalWeightGrains: parseJsonDoubleOrNull(json['totalWeightGrains']),
    );
  }
}

class ArrowRecommendationResult {
  const ArrowRecommendationResult({
    this.setupId,
    required this.chartId,
    required this.chartName,
    required this.effectiveDrawWeightLbs,
    required this.recommendations,
    required this.spines,
    required this.arrows,
    this.message,
  });

  final int? setupId;
  final int chartId;
  final String chartName;
  final double effectiveDrawWeightLbs;
  final ArrowRecommendations recommendations;
  final List<SpineMatch> spines;
  final List<CompatibleArrow> arrows;
  final String? message;

  factory ArrowRecommendationResult.fromJson(Map<String, dynamic> json) {
    return ArrowRecommendationResult(
      setupId: parseJsonIntOrNull(json['setupId']),
      chartId: parseJsonInt(json['chartId']),
      chartName: json['chartName'] as String,
      effectiveDrawWeightLbs: parseJsonDouble(json['effectiveDrawWeightLbs']),
      recommendations: ArrowRecommendations.fromJson(
        json['recommendations'] as Map<String, dynamic>,
      ),
      spines: (json['spines'] as List<dynamic>)
          .map((e) => SpineMatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      arrows: (json['arrows'] as List<dynamic>)
          .map((e) => CompatibleArrow.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );
  }
}
