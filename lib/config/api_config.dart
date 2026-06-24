import 'package:flutter/foundation.dart';

class ApiConfig {
  /// URL de producción en Render.
  /// Tras desplegar, actualiza aquí o compila con:
  /// --dart-define=API_PRODUCTION_URL=https://myarrows-api.onrender.com
  static const String _productionDefault = String.fromEnvironment(
    'API_PRODUCTION_URL',
    defaultValue: 'https://apps-lw0x.onrender.com',
  );

  /// URL base de la API.
  ///
  /// - Debug + emulador: http://10.0.2.2:3000 (API local)
  /// - Release: Render (HTTPS)
  /// - Override: --dart-define=API_BASE_URL=...
  static String get baseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) return override;
    if (kDebugMode) return 'http://10.0.2.2:3000';
    return _productionDefault;
  }
}
