int parseJsonInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('No es un entero: $value');
}

int? parseJsonIntOrNull(dynamic value) {
  if (value == null) return null;
  return parseJsonInt(value);
}

double parseJsonDouble(dynamic value) {
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.parse(value);
  throw FormatException('No es un número: $value');
}

double? parseJsonDoubleOrNull(dynamic value) {
  if (value == null) return null;
  return parseJsonDouble(value);
}
