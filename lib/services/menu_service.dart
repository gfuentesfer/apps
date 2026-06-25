import '../database/menu_repository.dart';
import '../models/menu_item.dart';

class MenuService {
  MenuService({MenuRepository? repository})
      : _repository = repository ?? MenuRepository();

  final MenuRepository _repository;

  Future<List<MenuItem>> fetchMenuItems() async {
    try {
      return _repository.fetchMenuItems();
    } catch (e) {
      throw MenuServiceException('Error al cargar el menú: $e');
    }
  }
}

class MenuServiceException implements Exception {
  MenuServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
