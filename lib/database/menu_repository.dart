import 'package:sqflite/sqflite.dart';

import '../models/menu_item.dart';
import 'app_database.dart';

class MenuRepository {
  MenuRepository([Future<Database>? db]) : _db = db ?? AppDatabase.instance;

  final Future<Database> _db;

  Future<List<MenuItem>> fetchMenuItems() async {
    final db = await _db;
    final rows = await db.rawQuery(
      '''
      SELECT id, title, subtitle, icon_name AS iconName, route, sort_order AS sortOrder
      FROM menu_options
      WHERE is_active = 1
      ORDER BY sort_order ASC, id ASC
      ''',
    );

    return rows
        .map(
          (r) => MenuItem(
            id: r['id'] as int,
            title: r['title'] as String,
            subtitle: r['subtitle'] as String?,
            iconName: r['iconName'] as String? ?? 'menu',
            route: r['route'] as String,
            sortOrder: r['sortOrder'] as int? ?? 0,
          ),
        )
        .toList();
  }
}
