import 'package:flutter/foundation.dart';

/// IDs de AdMob — MyArrows (Android).
/// En debug se usan banners de prueba de Google para no infringir políticas.
class AdConfig {
  AdConfig._();

  static const String androidAppId = String.fromEnvironment(
    'ADMOB_ANDROID_APP_ID',
    defaultValue: 'ca-app-pub-2306610483016230~9322448094',
  );

  static const String iosAppId = String.fromEnvironment(
    'ADMOB_IOS_APP_ID',
    defaultValue: 'ca-app-pub-3940256099942544~1458002511',
  );

  static const String _androidBannerProduction =
      'ca-app-pub-2306610483016230/3659057879';

  static const String _androidBannerTest =
      'ca-app-pub-3940256099942544/6300978111';

  static const String _iosBannerTest =
      'ca-app-pub-3940256099942544/2934735716';

  static String get androidBannerId {
    const fromEnv = String.fromEnvironment('ADMOB_ANDROID_BANNER_ID');
    if (fromEnv.isNotEmpty) return fromEnv;
    if (kDebugMode) return _androidBannerTest;
    return _androidBannerProduction;
  }

  static String get iosBannerId {
    const fromEnv = String.fromEnvironment('ADMOB_IOS_BANNER_ID');
    if (fromEnv.isNotEmpty) return fromEnv;
    return _iosBannerTest;
  }

  static bool get usingTestAds => kDebugMode;
}
