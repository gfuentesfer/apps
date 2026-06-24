import 'package:flutter/foundation.dart';

/// IDs de AdMob.
///
/// En desarrollo se usan los de prueba de Google. Para producción, crea la app
/// en https://admob.google.com y pásalos con --dart-define al compilar:
///
/// flutter build apk --dart-define=ADMOB_ANDROID_APP_ID=ca-app-pub-xxx~yyy \
///   --dart-define=ADMOB_ANDROID_BANNER_ID=ca-app-pub-xxx/zzz
class AdConfig {
  AdConfig._();

  static const String androidAppId = String.fromEnvironment(
    'ADMOB_ANDROID_APP_ID',
    defaultValue: 'ca-app-pub-3940256099942544~3347511713',
  );

  static const String iosAppId = String.fromEnvironment(
    'ADMOB_IOS_APP_ID',
    defaultValue: 'ca-app-pub-3940256099942544~1458002511',
  );

  static const String androidBannerId = String.fromEnvironment(
    'ADMOB_ANDROID_BANNER_ID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111',
  );

  static const String iosBannerId = String.fromEnvironment(
    'ADMOB_IOS_BANNER_ID',
    defaultValue: 'ca-app-pub-3940256099942544/2934735716',
  );

  static bool get usingTestAds =>
      kDebugMode &&
      androidBannerId.startsWith('ca-app-pub-3940256099942544');
}
