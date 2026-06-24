import 'package:flutter_test/flutter_test.dart';

import 'package:myarrowsapp/models/menu_item.dart';

void main() {
  test('MenuItem parses JSON from API', () {
    final item = MenuItem.fromJson({
      'id': 1,
      'title': 'Inicio',
      'subtitle': 'Pantalla principal',
      'iconName': 'home',
      'route': 'home',
      'sortOrder': 10,
    });

    expect(item.route, 'home');
    expect(item.iconName, 'home');
  });
}
