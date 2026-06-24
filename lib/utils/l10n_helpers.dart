import 'package:myarrowsapp/l10n/app_localizations.dart';

import '../models/menu_item.dart';

extension MenuItemL10n on AppLocalizations {
  String menuTitle(MenuItem item) {
    switch (item.route) {
      case 'home':
        return menuHome;
      case 'profile':
        return menuProfile;
      case 'settings':
        return menuSettings;
      case 'arrows':
        return menuArrows;
      default:
        return item.title;
    }
  }

  String? menuSubtitle(MenuItem item) {
    switch (item.route) {
      case 'home':
        return menuHomeSubtitle;
      case 'profile':
        return menuProfileSubtitle;
      case 'settings':
        return menuSettingsSubtitle;
      case 'arrows':
        return menuArrowsSubtitle;
      default:
        return item.subtitle;
    }
  }
}

extension CatalogL10n on AppLocalizations {
  String bowTypeLabel(String code, String fallback) {
    switch (code) {
      case 'RECURVE':
        return bowTypeRecurve;
      case 'BAREBOW':
        return bowTypeBarebow;
      case 'TRADITIONAL':
        return bowTypeTraditional;
      case 'COMPOUND':
        return bowTypeCompound;
      default:
        return fallback;
    }
  }

  String shootingStyleLabel(String code, String fallback) {
    switch (code) {
      case 'OLYMPIC_RECURVE':
        return styleOlympicRecurve;
      case 'BAREBOW_STANDARD':
        return styleBarebowStandard;
      case 'BAREBOW_STRINGWALKING':
        return styleBarebowStringwalking;
      case 'TRADITIONAL_FINGER':
        return styleTraditionalFinger;
      case 'COMPOUND_RELEASE':
        return styleCompoundRelease;
      default:
        return fallback;
    }
  }

  String arrowModelDescription(String modelName, String? fallback) {
    switch (modelName) {
      case 'X10':
        return arrowModelX10;
      case 'ACE':
        return arrowModelAce;
      case 'A/C Pro':
        return arrowModelAcPro;
      case 'Navigator':
        return arrowModelNavigator;
      case 'Jazz':
        return arrowModelJazz;
      case 'FMJ':
        return arrowModelFmj;
      case 'Axis':
        return arrowModelAxis;
      default:
        return fallback ?? arrowModelGeneric;
    }
  }
}
