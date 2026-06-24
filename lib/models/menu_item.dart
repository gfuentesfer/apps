import '../utils/json_parse.dart';

class MenuItem {
  const MenuItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.route,
    required this.sortOrder,
  });

  final int id;
  final String title;
  final String? subtitle;
  final String iconName;
  final String route;
  final int sortOrder;

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: parseJsonInt(json['id']),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      iconName: json['iconName'] as String? ?? 'menu',
      route: json['route'] as String,
      sortOrder: parseJsonIntOrNull(json['sortOrder']) ?? 0,
    );
  }
}
