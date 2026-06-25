// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MyArrows';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Retry';

  @override
  String get required => 'Required';

  @override
  String get user => 'User';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get email => 'Email';

  @override
  String get emailRequired => 'Enter your email';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get signIn => 'Sign in';

  @override
  String get noAccountRegister => 'Don\'t have an account? Sign up';

  @override
  String get createAccount => 'Create account';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Enter your name';

  @override
  String get passwordMinLength => 'At least 6 characters';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get register => 'Register';

  @override
  String get profileCreateFailed =>
      'Could not create profile. Please try again.';

  @override
  String get menu => 'Menu';

  @override
  String get reloadMenu => 'Reload menu';

  @override
  String get menuLoadError => 'Could not load menu';

  @override
  String routeNotConfigured(String route) {
    return 'Route not configured: $route';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirmTitle => 'Sign out';

  @override
  String get signOutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get settingsComingSoon => 'Settings coming soon';

  @override
  String get menuHome => 'Home';

  @override
  String get menuHomeSubtitle => 'Main screen';

  @override
  String get homeWelcome => 'Your arrow assistant';

  @override
  String get homeSubtitle =>
      'Calculate spine, length, and compatible models for your bow and shooting style.';

  @override
  String get menuProfile => 'My profile';

  @override
  String get menuProfileSubtitle => 'View and edit your profile';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuSettingsSubtitle => 'App settings';

  @override
  String get menuArrows => 'Arrow calculator';

  @override
  String get menuArrowsSubtitle => 'Spine, length and models by brand';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get emailCannotChange => 'Email cannot be changed';

  @override
  String get profileLoadError => 'Could not load profile.';

  @override
  String get profileSaveError => 'Could not save profile. Please try again.';

  @override
  String get profileNotFound => 'Profile not found in Firestore.';

  @override
  String get editProfileTooltip => 'Edit profile';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageEnglish => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get settingsLanguageSubtitle => 'Choose app language';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privacyPolicySubtitle => 'How we handle your data';

  @override
  String get arrowCalculator => 'Arrow calculator';

  @override
  String get yourBow => 'Your bow';

  @override
  String get arrowBrand => 'Arrow brand';

  @override
  String get bowType => 'Bow type';

  @override
  String get shootingStyle => 'Shooting style';

  @override
  String get drawWeight => 'Draw weight';

  @override
  String get drawWeightRange => 'Between 10 and 100 lbs';

  @override
  String get drawLength => 'Draw length';

  @override
  String get drawLengthRange => 'Between 20 and 34\"';

  @override
  String get bowSpeedFps => 'Bow speed (FPS)';

  @override
  String get fpsUnknown => 'I don\'t know my bow speed (FPS)';

  @override
  String get fpsUnknownHint =>
      'Calculation uses draw weight and point only, without speed adjustment';

  @override
  String get adjustedByPointOnly =>
      'Based on draw weight and point (no FPS adjustment)';

  @override
  String get compoundBowBrand => 'Compound bow brand';

  @override
  String get compoundBowBrandHint =>
      'Optional: pick your bow to load manufacturer IBO speed';

  @override
  String get compoundBowManual => 'Other / enter manually';

  @override
  String get compoundBowModel => 'Bow model';

  @override
  String get compoundBowSelectModel => 'Select model…';

  @override
  String compoundBowIboFps(int fps) {
    return '$fps FPS IBO';
  }

  @override
  String fpsFromBowModel(String model, int fps) {
    return 'Manufacturer IBO: $model ($fps FPS)';
  }

  @override
  String get fpsManualOverride => 'Speed adjusted manually';

  @override
  String chartLabel(String name) {
    return 'Chart: $name';
  }

  @override
  String fpsReference(int min, int max) {
    return '(ref. $min–$max)';
  }

  @override
  String get calculating => 'Calculating…';

  @override
  String get calculateArrow => 'Calculate arrow';

  @override
  String get recommendation => 'Recommendation';

  @override
  String get arrowLength => 'Arrow length';

  @override
  String get drawLengthPlusOne => 'Draw length + 1\"';

  @override
  String get spine => 'Spine';

  @override
  String get recommendedPoint => 'Recommended point';

  @override
  String pointGrains(int grains) {
    return '$grains gr';
  }

  @override
  String perChart(String name) {
    return 'Per chart $name';
  }

  @override
  String get effectiveWeight => 'Effective weight';

  @override
  String get adjustedByFpsPoint => 'Adjusted for FPS and point weight';

  @override
  String compatibleModels(int count) {
    return 'Compatible models ($count)';
  }

  @override
  String get noModelsForSpine => 'No catalog models for this spine.';

  @override
  String spineLabel(String label) {
    return 'Spine $label';
  }

  @override
  String shaftWeight(String weight) {
    return 'Shaft $weight gr';
  }

  @override
  String totalWeight(String weight) {
    return 'Total ~$weight gr';
  }

  @override
  String maxLength(String length) {
    return 'Max $length\"';
  }

  @override
  String get bowTypeRecurve => 'Olympic / ILF recurve bow';

  @override
  String get bowTypeBarebow => 'Barebow';

  @override
  String get bowTypeTraditional => 'Traditional / longbow / self bow';

  @override
  String get bowTypeCompound => 'Compound bow';

  @override
  String get styleOlympicRecurve => 'Olympic recurve (fingers)';

  @override
  String get styleBarebowStandard => 'Standard barebow';

  @override
  String get styleBarebowStringwalking => 'Barebow string walking';

  @override
  String get styleTraditionalFinger => 'Traditional with fingers';

  @override
  String get styleCompoundRelease => 'Compound (release aid)';

  @override
  String get authInvalidEmail => 'The email is not valid.';

  @override
  String get authUserDisabled => 'This account is disabled.';

  @override
  String get authWrongCredentials => 'Incorrect email or password.';

  @override
  String get authEmailInUse => 'An account with this email already exists.';

  @override
  String get authWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get authTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get authGenericError => 'Authentication error. Please try again.';

  @override
  String get authConfigurationNotFound =>
      'Firebase Authentication is not set up. In the Firebase console open Authentication, click Get started, and enable Email/Password.';

  @override
  String get arrowModelX10 => 'Premium Olympic arrow';

  @override
  String get arrowModelAce => 'Competition alloy/carbon';

  @override
  String get arrowModelAcPro => 'Competition alloy/carbon pro';

  @override
  String get arrowModelNavigator => 'Outdoor aluminum recurve';

  @override
  String get arrowModelJazz => 'Beginner aluminum';

  @override
  String get arrowModelFmj => 'Full metal jacket hunting';

  @override
  String get arrowModelAxis => 'Carbon hunting';

  @override
  String get arrowModelGeneric => 'Arrow shaft';
}
