import '../database/arrow_repository.dart';
import '../models/arrow_recommendation.dart';
import '../models/catalog_models.dart';

class ArrowService {
  ArrowService({ArrowRepository? repository})
      : _repository = repository ?? ArrowRepository();

  final ArrowRepository _repository;

  Future<List<BowType>> fetchBowTypes() async {
    return _repository.fetchBowTypes();
  }

  Future<List<ShootingStyle>> fetchShootingStyles({int? bowTypeId}) async {
    return _repository.fetchShootingStyles(bowTypeId: bowTypeId);
  }

  Future<List<Manufacturer>> fetchManufacturers() async {
    return _repository.fetchManufacturers();
  }

  Future<List<ManufacturerChart>> fetchCharts({
    required int manufacturerId,
  }) async {
    return _repository.fetchCharts(manufacturerId: manufacturerId);
  }

  Future<List<CompoundBowBrand>> fetchCompoundBowBrands() async {
    return _repository.fetchCompoundBowBrands();
  }

  Future<List<CompoundBowModel>> fetchCompoundBowModels({
    required int brandId,
  }) async {
    return _repository.fetchCompoundBowModels(brandId: brandId);
  }

  Future<ArrowRecommendationResult> recommend({
    required int manufacturerId,
    required int bowTypeId,
    int? shootingStyleId,
    required double drawWeightLbs,
    required double drawLengthInches,
    int? speedFps,
  }) async {
    try {
      return await _repository.recommend(
        manufacturerId: manufacturerId,
        bowTypeId: bowTypeId,
        shootingStyleId: shootingStyleId,
        drawWeightLbs: drawWeightLbs,
        drawLengthInches: drawLengthInches,
        speedFps: speedFps,
      );
    } on ArrowRepositoryException catch (e) {
      throw ArrowServiceException(e.message);
    }
  }
}

class ArrowServiceException implements Exception {
  ArrowServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
