import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MyArrows'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordRequired;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @noAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get noAccountRegister;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @profileCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create profile. Please try again.'**
  String get profileCreateFailed;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @reloadMenu.
  ///
  /// In en, this message translates to:
  /// **'Reload menu'**
  String get reloadMenu;

  /// No description provided for @menuLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load menu'**
  String get menuLoadError;

  /// No description provided for @routeNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Route not configured: {route}'**
  String routeNotConfigured(String route);

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmMessage;

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Settings coming soon'**
  String get settingsComingSoon;

  /// No description provided for @menuHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get menuHome;

  /// No description provided for @menuHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Main screen'**
  String get menuHomeSubtitle;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Your arrow assistant'**
  String get homeWelcome;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calculate spine, length, and compatible models for your bow and shooting style.'**
  String get homeSubtitle;

  /// No description provided for @menuProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get menuProfile;

  /// No description provided for @menuProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and edit your profile'**
  String get menuProfileSubtitle;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get menuSettingsSubtitle;

  /// No description provided for @menuArrows.
  ///
  /// In en, this message translates to:
  /// **'Arrow calculator'**
  String get menuArrows;

  /// No description provided for @menuArrowsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Spine, length and models by brand'**
  String get menuArrowsSubtitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @emailCannotChange.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed'**
  String get emailCannotChange;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile.'**
  String get profileLoadError;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save profile. Please try again.'**
  String get profileSaveError;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found in Firestore.'**
  String get profileNotFound;

  /// No description provided for @editProfileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTooltip;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get privacyPolicySubtitle;

  /// No description provided for @arrowCalculator.
  ///
  /// In en, this message translates to:
  /// **'Arrow calculator'**
  String get arrowCalculator;

  /// No description provided for @yourBow.
  ///
  /// In en, this message translates to:
  /// **'Your bow'**
  String get yourBow;

  /// No description provided for @arrowBrand.
  ///
  /// In en, this message translates to:
  /// **'Arrow brand'**
  String get arrowBrand;

  /// No description provided for @bowType.
  ///
  /// In en, this message translates to:
  /// **'Bow type'**
  String get bowType;

  /// No description provided for @shootingStyle.
  ///
  /// In en, this message translates to:
  /// **'Shooting style'**
  String get shootingStyle;

  /// No description provided for @drawWeight.
  ///
  /// In en, this message translates to:
  /// **'Draw weight'**
  String get drawWeight;

  /// No description provided for @drawWeightRange.
  ///
  /// In en, this message translates to:
  /// **'Between 10 and 100 lbs'**
  String get drawWeightRange;

  /// No description provided for @drawLength.
  ///
  /// In en, this message translates to:
  /// **'Draw length'**
  String get drawLength;

  /// No description provided for @drawLengthRange.
  ///
  /// In en, this message translates to:
  /// **'Between 20 and 34\"'**
  String get drawLengthRange;

  /// No description provided for @bowSpeedFps.
  ///
  /// In en, this message translates to:
  /// **'Bow speed (FPS)'**
  String get bowSpeedFps;

  /// No description provided for @fpsUnknown.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know my bow speed (FPS)'**
  String get fpsUnknown;

  /// No description provided for @fpsUnknownHint.
  ///
  /// In en, this message translates to:
  /// **'Calculation uses draw weight and point only, without speed adjustment'**
  String get fpsUnknownHint;

  /// No description provided for @adjustedByPointOnly.
  ///
  /// In en, this message translates to:
  /// **'Based on draw weight and point (no FPS adjustment)'**
  String get adjustedByPointOnly;

  /// No description provided for @compoundBowBrand.
  ///
  /// In en, this message translates to:
  /// **'Compound bow brand'**
  String get compoundBowBrand;

  /// No description provided for @compoundBowBrandHint.
  ///
  /// In en, this message translates to:
  /// **'Optional: pick your bow to load manufacturer IBO speed'**
  String get compoundBowBrandHint;

  /// No description provided for @compoundBowManual.
  ///
  /// In en, this message translates to:
  /// **'Other / enter manually'**
  String get compoundBowManual;

  /// No description provided for @compoundBowModel.
  ///
  /// In en, this message translates to:
  /// **'Bow model'**
  String get compoundBowModel;

  /// No description provided for @compoundBowSelectModel.
  ///
  /// In en, this message translates to:
  /// **'Select model…'**
  String get compoundBowSelectModel;

  /// No description provided for @compoundBowIboFps.
  ///
  /// In en, this message translates to:
  /// **'{fps} FPS IBO'**
  String compoundBowIboFps(int fps);

  /// No description provided for @fpsFromBowModel.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer IBO: {model} ({fps} FPS)'**
  String fpsFromBowModel(String model, int fps);

  /// No description provided for @fpsManualOverride.
  ///
  /// In en, this message translates to:
  /// **'Speed adjusted manually'**
  String get fpsManualOverride;

  /// No description provided for @chartLabel.
  ///
  /// In en, this message translates to:
  /// **'Chart: {name}'**
  String chartLabel(String name);

  /// No description provided for @fpsReference.
  ///
  /// In en, this message translates to:
  /// **'(ref. {min}–{max})'**
  String fpsReference(int min, int max);

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating…'**
  String get calculating;

  /// No description provided for @calculateArrow.
  ///
  /// In en, this message translates to:
  /// **'Calculate arrow'**
  String get calculateArrow;

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendation;

  /// No description provided for @arrowLength.
  ///
  /// In en, this message translates to:
  /// **'Arrow length'**
  String get arrowLength;

  /// No description provided for @drawLengthPlusOne.
  ///
  /// In en, this message translates to:
  /// **'Draw length + 1\"'**
  String get drawLengthPlusOne;

  /// No description provided for @spine.
  ///
  /// In en, this message translates to:
  /// **'Spine'**
  String get spine;

  /// No description provided for @recommendedPoint.
  ///
  /// In en, this message translates to:
  /// **'Recommended point'**
  String get recommendedPoint;

  /// No description provided for @pointGrains.
  ///
  /// In en, this message translates to:
  /// **'{grains} gr'**
  String pointGrains(int grains);

  /// No description provided for @perChart.
  ///
  /// In en, this message translates to:
  /// **'Per chart {name}'**
  String perChart(String name);

  /// No description provided for @effectiveWeight.
  ///
  /// In en, this message translates to:
  /// **'Effective weight'**
  String get effectiveWeight;

  /// No description provided for @adjustedByFpsPoint.
  ///
  /// In en, this message translates to:
  /// **'Adjusted for FPS and point weight'**
  String get adjustedByFpsPoint;

  /// No description provided for @compatibleModels.
  ///
  /// In en, this message translates to:
  /// **'Compatible models ({count})'**
  String compatibleModels(int count);

  /// No description provided for @noModelsForSpine.
  ///
  /// In en, this message translates to:
  /// **'No catalog models for this spine.'**
  String get noModelsForSpine;

  /// No description provided for @spineLabel.
  ///
  /// In en, this message translates to:
  /// **'Spine {label}'**
  String spineLabel(String label);

  /// No description provided for @shaftWeight.
  ///
  /// In en, this message translates to:
  /// **'Shaft {weight} gr'**
  String shaftWeight(String weight);

  /// No description provided for @totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total ~{weight} gr'**
  String totalWeight(String weight);

  /// No description provided for @maxLength.
  ///
  /// In en, this message translates to:
  /// **'Max {length}\"'**
  String maxLength(String length);

  /// No description provided for @bowTypeRecurve.
  ///
  /// In en, this message translates to:
  /// **'Olympic / ILF recurve bow'**
  String get bowTypeRecurve;

  /// No description provided for @bowTypeBarebow.
  ///
  /// In en, this message translates to:
  /// **'Barebow'**
  String get bowTypeBarebow;

  /// No description provided for @bowTypeTraditional.
  ///
  /// In en, this message translates to:
  /// **'Traditional / longbow / self bow'**
  String get bowTypeTraditional;

  /// No description provided for @bowTypeCompound.
  ///
  /// In en, this message translates to:
  /// **'Compound bow'**
  String get bowTypeCompound;

  /// No description provided for @styleOlympicRecurve.
  ///
  /// In en, this message translates to:
  /// **'Olympic recurve (fingers)'**
  String get styleOlympicRecurve;

  /// No description provided for @styleBarebowStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard barebow'**
  String get styleBarebowStandard;

  /// No description provided for @styleBarebowStringwalking.
  ///
  /// In en, this message translates to:
  /// **'Barebow string walking'**
  String get styleBarebowStringwalking;

  /// No description provided for @styleTraditionalFinger.
  ///
  /// In en, this message translates to:
  /// **'Traditional with fingers'**
  String get styleTraditionalFinger;

  /// No description provided for @styleCompoundRelease.
  ///
  /// In en, this message translates to:
  /// **'Compound (release aid)'**
  String get styleCompoundRelease;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email is not valid.'**
  String get authInvalidEmail;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account is disabled.'**
  String get authUserDisabled;

  /// No description provided for @authWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authWrongCredentials;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authWeakPassword;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get authTooManyRequests;

  /// No description provided for @authGenericError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please try again.'**
  String get authGenericError;

  /// No description provided for @authConfigurationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Firebase Authentication is not set up. In the Firebase console open Authentication, click Get started, and enable Email/Password.'**
  String get authConfigurationNotFound;

  /// No description provided for @arrowModelX10.
  ///
  /// In en, this message translates to:
  /// **'Premium Olympic arrow'**
  String get arrowModelX10;

  /// No description provided for @arrowModelAce.
  ///
  /// In en, this message translates to:
  /// **'Competition alloy/carbon'**
  String get arrowModelAce;

  /// No description provided for @arrowModelAcPro.
  ///
  /// In en, this message translates to:
  /// **'Competition alloy/carbon pro'**
  String get arrowModelAcPro;

  /// No description provided for @arrowModelNavigator.
  ///
  /// In en, this message translates to:
  /// **'Outdoor aluminum recurve'**
  String get arrowModelNavigator;

  /// No description provided for @arrowModelJazz.
  ///
  /// In en, this message translates to:
  /// **'Beginner aluminum'**
  String get arrowModelJazz;

  /// No description provided for @arrowModelFmj.
  ///
  /// In en, this message translates to:
  /// **'Full metal jacket hunting'**
  String get arrowModelFmj;

  /// No description provided for @arrowModelAxis.
  ///
  /// In en, this message translates to:
  /// **'Carbon hunting'**
  String get arrowModelAxis;

  /// No description provided for @arrowModelGeneric.
  ///
  /// In en, this message translates to:
  /// **'Arrow shaft'**
  String get arrowModelGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
