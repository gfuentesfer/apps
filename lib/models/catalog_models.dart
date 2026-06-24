import '../utils/json_parse.dart';

class BowType {
  const BowType({
    required this.id,
    required this.code,
    required this.description,
  });

  final int id;
  final String code;
  final String description;

  factory BowType.fromJson(Map<String, dynamic> json) {
    return BowType(
      id: parseJsonInt(json['id']),
      code: json['code'] as String,
      description: json['description'] as String,
    );
  }
}

class ShootingStyle {
  const ShootingStyle({
    required this.id,
    required this.code,
    required this.description,
    required this.bowTypeId,
  });

  final int id;
  final String code;
  final String description;
  final int bowTypeId;

  factory ShootingStyle.fromJson(Map<String, dynamic> json) {
    return ShootingStyle(
      id: parseJsonInt(json['id']),
      code: json['code'] as String,
      description: json['description'] as String,
      bowTypeId: parseJsonInt(json['bowTypeId']),
    );
  }
}

class Manufacturer {
  const Manufacturer({
    required this.id,
    required this.name,
    this.country,
    this.website,
  });

  final int id;
  final String name;
  final String? country;
  final String? website;

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: parseJsonInt(json['id']),
      name: json['name'] as String,
      country: json['country'] as String?,
      website: json['website'] as String?,
    );
  }
}

class ManufacturerChart {
  const ManufacturerChart({
    required this.id,
    required this.chartName,
    required this.bowType,
    this.shootingStyle,
    this.purpose,
    this.version,
    this.referenceFpsMin,
    this.referenceFpsMax,
    this.referencePointGrains,
  });

  final int id;
  final String chartName;
  final String bowType;
  final String? shootingStyle;
  final String? purpose;
  final String? version;
  final int? referenceFpsMin;
  final int? referenceFpsMax;
  final int? referencePointGrains;

  factory ManufacturerChart.fromJson(Map<String, dynamic> json) {
    return ManufacturerChart(
      id: parseJsonInt(json['id']),
      chartName: json['chartName'] as String,
      bowType: json['bowType'] as String,
      shootingStyle: json['shootingStyle'] as String?,
      purpose: json['purpose'] as String?,
      version: json['version'] as String?,
      referenceFpsMin: parseJsonIntOrNull(json['referenceFpsMin']),
      referenceFpsMax: parseJsonIntOrNull(json['referenceFpsMax']),
      referencePointGrains: parseJsonIntOrNull(json['referencePointGrains']),
    );
  }
}

class CompoundBowBrand {
  const CompoundBowBrand({
    required this.id,
    required this.name,
    this.country,
    this.website,
  });

  final int id;
  final String name;
  final String? country;
  final String? website;

  factory CompoundBowBrand.fromJson(Map<String, dynamic> json) {
    return CompoundBowBrand(
      id: parseJsonInt(json['id']),
      name: json['name'] as String,
      country: json['country'] as String?,
      website: json['website'] as String?,
    );
  }
}

class CompoundBowModel {
  const CompoundBowModel({
    required this.id,
    required this.brandId,
    required this.modelName,
    required this.iboFps,
    this.modelYear,
    this.drawWeightMinLbs,
    this.drawWeightMaxLbs,
    this.drawLengthMinIn,
    this.drawLengthMaxIn,
    this.axleToAxleIn,
    this.braceHeightIn,
    this.notes,
  });

  final int id;
  final int brandId;
  final String modelName;
  final int iboFps;
  final int? modelYear;
  final double? drawWeightMinLbs;
  final double? drawWeightMaxLbs;
  final double? drawLengthMinIn;
  final double? drawLengthMaxIn;
  final double? axleToAxleIn;
  final double? braceHeightIn;
  final String? notes;

  String get displayLabel {
    if (modelYear != null) {
      return '$modelName ($modelYear)';
    }
    return modelName;
  }

  factory CompoundBowModel.fromJson(Map<String, dynamic> json) {
    return CompoundBowModel(
      id: parseJsonInt(json['id']),
      brandId: parseJsonInt(json['brandId']),
      modelName: json['modelName'] as String,
      iboFps: parseJsonInt(json['iboFps']),
      modelYear: parseJsonIntOrNull(json['modelYear']),
      drawWeightMinLbs: parseJsonDoubleOrNull(json['drawWeightMinLbs']),
      drawWeightMaxLbs: parseJsonDoubleOrNull(json['drawWeightMaxLbs']),
      drawLengthMinIn: parseJsonDoubleOrNull(json['drawLengthMinIn']),
      drawLengthMaxIn: parseJsonDoubleOrNull(json['drawLengthMaxIn']),
      axleToAxleIn: parseJsonDoubleOrNull(json['axleToAxleIn']),
      braceHeightIn: parseJsonDoubleOrNull(json['braceHeightIn']),
      notes: json['notes'] as String?,
    );
  }
}
