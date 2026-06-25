// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'MyArrows';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get retry => 'Reintentar';

  @override
  String get required => 'Requerido';

  @override
  String get user => 'Usuario';

  @override
  String get loginSubtitle => 'Inicia sesión para continuar';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailRequired => 'Introduce tu correo';

  @override
  String get emailInvalid => 'Introduce un correo válido';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordRequired => 'Introduce tu contraseña';

  @override
  String get signIn => 'Entrar';

  @override
  String get noAccountRegister => '¿No tienes cuenta? Regístrate';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get name => 'Nombre';

  @override
  String get nameRequired => 'Introduce tu nombre';

  @override
  String get passwordMinLength => 'Mínimo 6 caracteres';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get register => 'Registrarse';

  @override
  String get profileCreateFailed =>
      'No se pudo crear el perfil. Inténtalo de nuevo.';

  @override
  String get menu => 'Menú';

  @override
  String get reloadMenu => 'Recargar menú';

  @override
  String get menuLoadError => 'No se pudo cargar el menú';

  @override
  String routeNotConfigured(String route) {
    return 'Ruta no configurada: $route';
  }

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signOutConfirmTitle => 'Cerrar sesión';

  @override
  String get signOutConfirmMessage => '¿Seguro que quieres salir?';

  @override
  String get settingsComingSoon => 'Configuración próximamente';

  @override
  String get menuHome => 'Inicio';

  @override
  String get menuHomeSubtitle => 'Pantalla principal';

  @override
  String get homeWelcome => 'Tu asistente de flechas';

  @override
  String get homeSubtitle =>
      'Calcula spine, longitud y modelos compatibles según tu arco y estilo de tiro.';

  @override
  String get menuProfile => 'Mi perfil';

  @override
  String get menuProfileSubtitle => 'Ver y editar tu perfil';

  @override
  String get menuSettings => 'Configuración';

  @override
  String get menuSettingsSubtitle => 'Ajustes de la aplicación';

  @override
  String get menuArrows => 'Calculadora de flechas';

  @override
  String get menuArrowsSubtitle => 'Spine, longitud y modelos por marca';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get emailCannotChange => 'El correo no se puede cambiar';

  @override
  String get profileLoadError => 'No se pudo cargar el perfil.';

  @override
  String get profileSaveError =>
      'No se pudo guardar el perfil. Inténtalo de nuevo.';

  @override
  String get profileNotFound => 'Perfil no encontrado en Firestore.';

  @override
  String get editProfileTooltip => 'Editar perfil';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get settings => 'Configuración';

  @override
  String get settingsLanguageSubtitle => 'Elige el idioma de la aplicación';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get privacyPolicySubtitle => 'Cómo tratamos tus datos';

  @override
  String get arrowCalculator => 'Calculadora de flechas';

  @override
  String get yourBow => 'Tu arco';

  @override
  String get arrowBrand => 'Marca de flecha';

  @override
  String get bowType => 'Tipo de arco';

  @override
  String get shootingStyle => 'Estilo de tiro';

  @override
  String get drawWeight => 'Potencia';

  @override
  String get drawWeightRange => 'Entre 10 y 100 lbs';

  @override
  String get drawLength => 'Apertura';

  @override
  String get drawLengthRange => 'Entre 20 y 34\"';

  @override
  String get bowSpeedFps => 'Velocidad del arco (FPS)';

  @override
  String get fpsUnknown => 'No conozco la velocidad de mi arco (FPS)';

  @override
  String get fpsUnknownHint =>
      'El cálculo usará solo la potencia y la punta, sin ajuste por velocidad';

  @override
  String get adjustedByPointOnly =>
      'Según potencia y punta (sin ajuste por FPS)';

  @override
  String get compoundBowBrand => 'Marca del arco compuesto';

  @override
  String get compoundBowBrandHint =>
      'Opcional: selecciona tu arco para cargar el IBO del fabricante';

  @override
  String get compoundBowManual => 'Otro / introducir manualmente';

  @override
  String get compoundBowModel => 'Modelo del arco';

  @override
  String get compoundBowSelectModel => 'Seleccionar modelo…';

  @override
  String compoundBowIboFps(int fps) {
    return '$fps FPS IBO';
  }

  @override
  String fpsFromBowModel(String model, int fps) {
    return 'IBO según fabricante: $model ($fps FPS)';
  }

  @override
  String get fpsManualOverride => 'Velocidad ajustada manualmente';

  @override
  String chartLabel(String name) {
    return 'Chart: $name';
  }

  @override
  String fpsReference(int min, int max) {
    return '(ref. $min–$max)';
  }

  @override
  String get calculating => 'Calculando…';

  @override
  String get calculateArrow => 'Calcular flecha';

  @override
  String get recommendation => 'Recomendación';

  @override
  String get arrowLength => 'Longitud de flecha';

  @override
  String get drawLengthPlusOne => 'Apertura + 1\"';

  @override
  String get spine => 'Spine';

  @override
  String get recommendedPoint => 'Punta recomendada';

  @override
  String pointGrains(int grains) {
    return '$grains gr';
  }

  @override
  String perChart(String name) {
    return 'Según chart $name';
  }

  @override
  String get effectiveWeight => 'Peso efectivo';

  @override
  String get adjustedByFpsPoint => 'Ajustado por FPS y punta';

  @override
  String compatibleModels(int count) {
    return 'Modelos compatibles ($count)';
  }

  @override
  String get noModelsForSpine => 'No hay modelos en catálogo para este spine.';

  @override
  String spineLabel(String label) {
    return 'Spine $label';
  }

  @override
  String shaftWeight(String weight) {
    return 'Astil $weight gr';
  }

  @override
  String totalWeight(String weight) {
    return 'Total ~$weight gr';
  }

  @override
  String maxLength(String length) {
    return 'Máx $length\"';
  }

  @override
  String get bowTypeRecurve => 'Arco recurvo olímpico / ILF';

  @override
  String get bowTypeBarebow => 'Arco desnudo (barebow)';

  @override
  String get bowTypeTraditional => 'Arco tradicional / longbow / self bow';

  @override
  String get bowTypeCompound => 'Arco compuesto';

  @override
  String get styleOlympicRecurve => 'Recurvo olímpico (dedos)';

  @override
  String get styleBarebowStandard => 'Barebow estándar';

  @override
  String get styleBarebowStringwalking => 'Barebow string walking';

  @override
  String get styleTraditionalFinger => 'Tradicional con dedos';

  @override
  String get styleCompoundRelease => 'Compuesto con disparador';

  @override
  String get authInvalidEmail => 'El correo no es válido.';

  @override
  String get authUserDisabled => 'Esta cuenta está deshabilitada.';

  @override
  String get authWrongCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get authEmailInUse => 'Ya existe una cuenta con ese correo.';

  @override
  String get authWeakPassword =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get authTooManyRequests => 'Demasiados intentos. Prueba más tarde.';

  @override
  String get authGenericError => 'Error de autenticación. Inténtalo de nuevo.';

  @override
  String get authConfigurationNotFound =>
      'Firebase Authentication no está configurado. En la consola de Firebase abre Authentication, pulsa Comenzar y activa Correo/Contraseña.';

  @override
  String get arrowModelX10 => 'Flecha olímpica premium';

  @override
  String get arrowModelAce => 'Competition alloy/carbon';

  @override
  String get arrowModelAcPro => 'Competition alloy/carbon pro';

  @override
  String get arrowModelNavigator => 'Aluminio outdoor recurvo';

  @override
  String get arrowModelJazz => 'Aluminio principiante';

  @override
  String get arrowModelFmj => 'Full metal jacket caza';

  @override
  String get arrowModelAxis => 'Carbono caza';

  @override
  String get arrowModelGeneric => 'Astil de flecha';
}
